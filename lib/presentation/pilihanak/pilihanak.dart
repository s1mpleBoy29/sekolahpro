import 'package:flutter/material.dart';
import 'package:guardian_app/core/providers/student_provider.dart';
import 'package:guardian_app/data/models/student.dart';
import 'package:guardian_app/presentation/pilihanak/searchbar.dart';
import 'package:guardian_app/presentation/pilihanak/studentcard.dart';
import 'package:guardian_app/widgets/ad_card.dart';
import 'package:guardian_app/presentation/home/home.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guardian_app/data/api/ad.dart';
import 'package:guardian_app/data/models/ad.dart';
import 'dart:async';

enum PostSelectionAction {
  goBack,
  navigateToHome,
}

class PilihAnakScreen extends StatefulWidget {
  final PostSelectionAction postSelectionAction;

  const PilihAnakScreen({
    super.key,
    this.postSelectionAction = PostSelectionAction.goBack,
  });

  @override
  PilihAnakPageScreen createState() => PilihAnakPageScreen();
}

class PilihAnakPageScreen extends State<PilihAnakScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Student> allChildren = [];
  List<Student> _filteredChildren = [];
  //Ads
  List<Ad> _adList = [];
  int _currentAdIndex = 0;
  Timer? _adTimer;
  // end Ads

  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _fetchAndStartAds();
  }

  void _fetchAndStartAds() async {
    final ads = await getAds();
    if (mounted && ads != null && ads.isNotEmpty) {
      setState(() {
        _adList = ads;
      });
      if (ads.length > 1) {
        _startAdTimer();
      }
    }
  }

  void _startAdTimer() {
    _adTimer?.cancel();
    _adTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentAdIndex = (_currentAdIndex + 1) % _adList.length;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    _prefs = await SharedPreferences.getInstance();
    loadStudent();
  }

  Future<void> loadStudent() async {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    final students = provider.students;

    setState(() {
      allChildren = students;
      _filteredChildren = students; // default tampil semua
    });
  }

  void _filterChildren(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredChildren = allChildren;
      } else {
        _filteredChildren = allChildren.where((child) {
          final name = child.fullName?.toLowerCase() ?? '';
          final school = child.schoolName?.toLowerCase() ?? '';
          final grade = child.gradeName?.toLowerCase() ?? '';
          final search = query.toLowerCase();

          return name.contains(search) ||
              school.contains(search) ||
              grade.contains(search);
        }).toList();
      }
    });
  }

  void _onSelectChild(Student childData) {
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    studentProvider.setSelectedStudent(childData);

    switch (widget.postSelectionAction) {
      case PostSelectionAction.navigateToHome:
        // Untuk case login.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        break;

      case PostSelectionAction.goBack:
        // Default
        Future.delayed(Duration.zero, () {
          if (mounted) {
            Navigator.pop(context, childData);
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double adCardEstimatedHeight =
        120.0; // Tinggi AdCard + padding bottom

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Background blur.png (Fixed)
          Positioned.fill(
            top: -50,
            child: Image.asset(
              'assets/images/blur.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                      top: 60.0,
                      left: 20.0,
                      right: 20.0), // Padding disesuaikan
                  child: Text(
                    'Pilih Anak',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0), // Padding horizontal
                  child: CustomSearchBar(
                    controller: _searchController,
                    hintText: 'Cari nama, kelas, dll',
                    onChanged: _filterChildren,
                    onSubmitted: (text) {
                      _filterChildren(text);
                      FocusScope.of(context).unfocus();
                    },
                    onSearchTap: () {
                      _filterChildren(_searchController.text);
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                const SizedBox(height: 16.0), // Spasi setelah search bar

                // Daftar StudentCard (Hanya ini yang akan discroll)
                Expanded(
                  // Expanded agar ListView.builder mengisi sisa ruang yang tersedia
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0), // Padding horizontal untuk daftar
                    child: _filteredChildren.isEmpty
                        ? const Center(
                            child: Text('Tidak ada anak ditemukan.'),
                          )
                        : ListView.builder(
                            itemCount: _filteredChildren.length,
                            itemBuilder: (context, index) {
                              final childData = _filteredChildren[index];

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: StudentCard(
                                  studentName: childData.fullName,
                                  schoolName: childData.schoolName,
                                  className: childData.gradeName,
                                  avatarImagePath: null,
                                  onSelectPressed: () {
                                    _onSelectChild(childData);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: adCardEstimatedHeight),
              ],
            ),
          ),
          if (_adList.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AdCard(
                  ad: _adList[_currentAdIndex],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
