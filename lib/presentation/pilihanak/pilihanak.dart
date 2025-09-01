import 'package:flutter/material.dart';
import 'package:guardian_app/core/providers/student_provider.dart';
import 'package:guardian_app/presentation/pilihanak/searchbar.dart';
import 'package:guardian_app/presentation/pilihanak/studentcard.dart';
import 'package:guardian_app/widgets/ad_card.dart';
import 'package:guardian_app/presentation/home/home.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

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

  List<Map<String, String>> allChildren = [];

  List<Map<String, String>> _filteredChildren = [];

  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    allChildren = _filteredChildren = allChildren;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> loadStudent() async {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    final students = provider.students;

    if (mounted) {
      setState(() {
        allChildren.clear();
        allChildren.addAll(students.isNotEmpty
            ? students
                .map((student) => {
                      'name': student.name,
                      'school': student.school,
                      'grade': student.grade,
                    })
                .toList()
            : []);
        // allChildren.clear();
        // allChildren.addAll(students.isNotEmpty
        //     ? students.map((student) => student).toList()
        //     : ["TUNAI"]);
        // _selectedPaymentMethod =
        //     _paymentMethods.contains(_selectedPaymentMethod)
        //         ? _selectedPaymentMethod
        //         : _paymentMethods.first;
      });
    }
  }

  void _filterChildren(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredChildren = allChildren;
      } else {
        _filteredChildren = allChildren
            .where((child) =>
                child['name']!.toLowerCase().contains(query.toLowerCase()) ||
                child['school']!.toLowerCase().contains(query.toLowerCase()) ||
                child['class']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _onSelectChild(Map<String, String> childData) {
    print('Anak yang dipilih: ${childData['name']}');

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
    // Estimasi tinggi AdCard untuk padding bawah
    // Anda mungkin perlu menyesuaikannya agar pas dengan tinggi AdCard yang sebenarnya
    final double adCardEstimatedHeight =
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

          // 2. Konten Utama: Judul, Search Bar, dan Daftar Anak (Semua dalam satu Column)
          // SafeArea akan memastikan konten tidak tumpang tindih dengan status bar/notch
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul "Pilih Anak" (Fixed)
                Padding(
                  padding: const EdgeInsets.only(
                      top: 60.0,
                      left: 20.0,
                      right: 20.0), // Padding disesuaikan
                  child: const Text(
                    'Pilih Anak',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0), // Spasi setelah judul

                // Search Bar (Fixed)
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
                            // Tidak perlu shrinkWrap dan NeverScrollableScrollPhysics lagi
                            // karena sudah di dalam Expanded SingleChildScrollView atau langsung Expanded ListView.builder
                            // Jika list ini terlalu panjang dan butuh scroll, maka dia sendiri yang akan scroll
                            itemCount: _filteredChildren.length,
                            itemBuilder: (context, index) {
                              final childData = _filteredChildren[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: StudentCard(
                                  studentName: childData['name']!,
                                  schoolName: childData['school']!,
                                  className: childData['class']!,
                                  avatarImagePath:
                                      'assets/images/profileicon.jpg',
                                  onSelectPressed: () {
                                    _onSelectChild(childData);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ),

                // Tambahkan padding di bagian bawah kolom utama agar AdCard tidak menutupi item terakhir
                SizedBox(
                    height:
                        adCardEstimatedHeight), // Pastikan ada ruang untuk AdCard
              ],
            ),
          ),

          // 3. Fixed AdCard di bagian bawah (Paling atas secara visual dalam Stack)
          Positioned(
            bottom: 0, // Jepit ke bagian bawah layar
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Padding di sekitar AdCard
              child: AdCard(
                teks:
                    "Ads\nIn the lessons we learn new words and for vocabularities continues and article...",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
