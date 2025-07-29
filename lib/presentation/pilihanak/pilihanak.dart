import 'package:flutter/material.dart';
import 'package:guardian_app/presentation/pilihanak/searchbar.dart';
import 'package:guardian_app/presentation/pilihanak/studentcard.dart';
import 'package:guardian_app/widgets/ad_card.dart';
import 'package:guardian_app/presentation/home.dart';
import 'dart:ui';

class PilihAnakScreen extends StatefulWidget {
  const PilihAnakScreen({super.key});

  @override
  PilihAnakPageScreen createState() => PilihAnakPageScreen();
}

class PilihAnakPageScreen extends State<PilihAnakScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> _allChildren = [
    {
      'name': 'Agus Supriyadi',
      'school': 'SDN 13 Malang',
      'class': 'Kelas 5',
      'avatar': 'assets/images/profileicon.jpg'
    },
    {
      'name': 'Andi Wiratama',
      'school': 'SDN 13 Malang',
      'class': 'Kelas 5',
      'avatar': 'assets/images/profileicon.jpg'
    },
    {
      'name': 'Budi Santosa',
      'school': 'SDN 13 Malang',
      'class': 'Kelas 5',
      'avatar': 'assets/images/profileicon.jpg'
    },
    {
      'name': 'Candra Wijaya',
      'school': 'SDN 13 Malang',
      'class': 'Kelas 5',
      'avatar': 'assets/images/profileicon.jpg'
    },
    {
      'name': 'Gina Kartika',
      'school': 'SDN 13 Malang',
      'class': 'Kelas 5',
      'avatar': 'assets/images/profileicon.jpg'
    },
    {
      'name': 'Hendro Lesmono',
      'school': 'SDN 13 Malang',
      'class': 'Kelas 5',
      'avatar': 'assets/images/profileicon.jpg'
    },
    {
      'name': 'Indah Pratama',
      'school': 'SDN 13 Malang',
      'class': 'Kelas 5',
      'avatar': 'assets/images/profileicon.jpg'
    },
  ];

  List<Map<String, String>> _filteredChildren = [];

  @override
  void initState() {
    super.initState();
    _filteredChildren = _allChildren;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterChildren(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredChildren = _allChildren;
      } else {
        _filteredChildren = _allChildren
            .where((child) =>
                child['name']!.toLowerCase().contains(query.toLowerCase()) ||
                child['school']!.toLowerCase().contains(query.toLowerCase()) ||
                child['class']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _onSelectChild(String childName) {
    print('Anak yang dipilih: $childName');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Estimasi tinggi AdCard untuk padding bawah
    // Anda mungkin perlu menyesuaikannya agar pas dengan tinggi AdCard yang sebenarnya
    final double adCardEstimatedHeight = 120.0; // Tinggi AdCard + padding bottom

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
                  padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0), // Padding disesuaikan
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding horizontal
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
                Expanded( // Expanded agar ListView.builder mengisi sisa ruang yang tersedia
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding horizontal untuk daftar
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
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: StudentCard(
                                  studentName: childData['name']!,
                                  schoolName: childData['school']!,
                                  className: childData['class']!,
                                  avatarImagePath: 'assets/images/profileicon.jpg',
                                  onSelectPressed: () {
                                    _onSelectChild(childData['name']!);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ),

                // Tambahkan padding di bagian bawah kolom utama agar AdCard tidak menutupi item terakhir
                SizedBox(height: adCardEstimatedHeight), // Pastikan ada ruang untuk AdCard
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
                text: "Ads\nIn the lessons we learn new words and for vocabularities continues and article...",
              ),
            ),
          ),
        ],
      ),
    );
  }
}