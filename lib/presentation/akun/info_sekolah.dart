import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:guardian_app/core/actions/school_action.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/core/providers/school_provider.dart';
import 'package:guardian_app/data/models/school.dart';
import 'package:guardian_app/presentation/info_sekolah/sekolahcard.dart';
import 'package:guardian_app/presentation/pilihanak/searchbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoSekolahScreen extends StatefulWidget {
  const InfoSekolahScreen({super.key});

  @override
  InfoSekolahPageScreen createState() => InfoSekolahPageScreen();
}

class InfoSekolahPageScreen extends State<InfoSekolahScreen> {
  List<School> allSchool = [];
  List<School> _filteredSchool = [];
  late String filterArea = 'smpn_13_malang';

  final TextEditingController _searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchSchool(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSchool = allSchool;
      } else {
        _filteredSchool = allSchool.where((child) {
          final name = child.name.toLowerCase();
          final school = child.schoolName.toLowerCase();
          final search = query.toLowerCase();

          return name.contains(search) || school.contains(search);
        }).toList();
      }
    });
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // filteredSekolahList = sekolahList;
    });
  }

  Future<void> loadSchool() async {
    final provider = Provider.of<SchoolProvider>(context, listen: false);

    final results = await Future.wait<dynamic>([
      SchoolAction.getSchool(),
    ]);

    final schools = results[0] as List<School>;
    await provider.saveSchool(schools);
    await provider.loadSchool();

    setState(() {
      allSchool = provider.schools;
      _filteredSchool = provider.schools;
    });
  }

  Future<void> _initializeData() async {
    loadSchool();
  }

  void _showFilterPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: appTheme.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter Sekolah',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Area',
                      style: CustomTextStyles.titleSmallGray600,
                    ),
                    const SizedBox(height: 10),
                    // Add filter options here
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Method untuk handle action buttons
  void sendEmail(String email) async {
    if (email != '-') {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          'subject': 'Info dari Aplikasi Guardian',
          'body': 'Saya ingin menanyakan tentang...',
        },
      );

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception("Tidak bisa membuka aplikasi email");
      }
    }
  }

  void openPhone(String telepon) {
    if (telepon != '-') {
      final Uri telUri = Uri(scheme: 'tel', path: telepon);
      launchUrl(telUri);
    }
  }

  Future<void> openMap(String geoJson) async {
    final data = jsonDecode(geoJson);
    final coords = data['features'][0]['geometry']['coordinates'];
    final double longitude = coords[0];
    final double latitude = coords[1];

    final Uri googleMapAppUrl =
        Uri.parse("geo:$latitude,$longitude?q=$latitude,$longitude");

    if (await canLaunchUrl(googleMapAppUrl)) {
      await launchUrl(googleMapAppUrl, mode: LaunchMode.externalApplication);
    } else {
      // fallback ke browser
      final Uri googleMapWebUrl = Uri.parse(
          "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");
      await launchUrl(googleMapWebUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        title: Text(
          'Info Sekolah',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.akunScreen)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0), // Padding horizontal
            child: CustomSearchBar(
              controller: _searchController,
              hintText: 'Cari nama sekolah',
              onChanged: _searchSchool,
              onSubmitted: (text) {
                _searchSchool(text);
                FocusScope.of(context).unfocus();
              },
              onSearchTap: () {
                _searchSchool(_searchController.text);
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Sekolah Tertaut',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),

          Expanded(
            // Expanded agar ListView.builder mengisi sisa ruang yang tersedia
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0), // Padding horizontal untuk daftar
              child: RefreshIndicator(
                onRefresh: () async {
                  await loadSchool(); // panggil fungsi reload data sekolah
                },
                child: _filteredSchool.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada anak ditemukan.',
                          style: TextStyle(
                            color: theme.colorScheme.outline,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredSchool.length,
                        itemBuilder: (context, index) {
                          final childData = _filteredSchool[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: SchoolCard(
                              schoolName: childData.schoolName,
                              phone: childData.phone,
                              email: childData.email,
                              address: childData.address,
                              city: childData.city,
                              onSendEmail: () => sendEmail(
                                childData.email,
                              ),
                              onPhone: () => openPhone(
                                childData.phone,
                              ),
                              onMap: () => openMap(
                                childData.map,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
          // ..._filteredSchool.map((school) {
          //   return Padding(
          //     padding: const EdgeInsets.symmetric(
          //       horizontal: 16,
          //       vertical: 6,
          //     ),
          //     child: SchoolCard(
          //       schoolName: school.schoolName,
          //       phone: school.phone,
          //       email: school.email,
          //       address: school.address,
          //       city: school.city,
          //       onSendEmail: () => _kirimEmail(
          //         school.email,
          //       ),
          //       onPhone: () => _telepon(
          //         school.phone,
          //       ),
          //       onMap: () => openMap(
          //         school.map,
          //       ),
          //     ),
          //   );
          // }),
        ],
      ),
    );
  }
}
