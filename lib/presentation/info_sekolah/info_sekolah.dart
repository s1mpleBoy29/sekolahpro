import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/presentation/info_sekolah/sekolahcard.dart';

class InfoSekolahScreen extends StatefulWidget {
  const InfoSekolahScreen({Key? key}) : super(key: key);

  @override
  InfoSekolahPageScreen createState() => InfoSekolahPageScreen();
}

class InfoSekolahPageScreen extends State<InfoSekolahScreen> {
  late String filterArea = 'smpn_13_malang';
  final TextEditingController _searchController = TextEditingController();

  // Data sekolah (mock data)
  List<Map<String, dynamic>> sekolahList = [
    {
      'nama': 'SMPN 13 Malang',
      'telepon': '(0341) 552864',
      'email': 'smpn13malang@gmail.com',
      'alamat':
          'Jl. Sultan Agung 2, RT 9/RW 2, Dinoyo, Kec. Lowokwaru, Kota Malang, Jawa Timur 65144',
    },
    {
      'nama': 'SD Katolik Mardi Wiyata 02',
      'telepon': '(0341) 366074',
      'email': '-',
      'alamat':
          'Jl. Semeru No.36, Dinoyo Dowo, Kec. Klojjen, Kota Malang, Jawa Timur 65112',
    },
  ];

  List<Map<String, dynamic>> filteredSekolahList = [];

  @override
  void initState() {
    super.initState();
    filteredSekolahList = sekolahList;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filteredSekolahList = sekolahList;
      } else {
        filteredSekolahList = sekolahList
            .where((sekolah) => sekolah['nama']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> onRefresh() async {
    // Implementasi refresh data sekolah
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      filteredSekolahList = sekolahList;
    });
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: appTheme.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
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
                    SizedBox(height: 20),
                    Text(
                      'Area',
                      style: CustomTextStyles.titleSmallGray600,
                    ),
                    SizedBox(height: 10),
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
  void _kirimEmail(String email) {
    if (email != '-') {
      print('Kirim email ke: $email');
    }
  }

  void _telepon(String telepon) {
    print('Telepon ke: $telepon');
  }

  void _lihatPeta(String alamat) {
    print('Lihat peta untuk alamat: $alamat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // 1. Tambahkan ini untuk membuat ikon status bar (jam, baterai) menjadi hitam.
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        // 2. 'foregroundColor' akan membuat judul DAN ikon tombol kembali menjadi hitam.
        foregroundColor: Colors.black,
        title: Text(
          'Info Sekolah',
          // Style di sini hanya untuk mengatur ukuran dan ketebalan font.
          // Warna sudah diatur oleh `foregroundColor`.
          style: TextStyle(
            color: Colors.black, // <-- BAGIAN INI BISA DIHAPUS JIKA FOREGROUND COLOR SUDAH DISET
            fontSize: 20, 
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        // Tombol kembali akan muncul otomatis di sebelah kiri judul
        // karena kita tidak mendefinisikan properti 'leading'.
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.akunScreen)
        ),
      ),
      body: Column(
        children: [
          Divider(
            height: 1,      // Tinggi total area divider
            thickness: 1,  // Ketebalan garis. Nilai 10 terlalu tebal.
            color: Colors.grey[500], // Warna abu-abu muda seperti desain
          ),
          // Search Bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 30, 16, 16), // Gunakan angka biasa
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tautkan Sekolah ...',
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          // Section Header
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Sekolah Tertaut',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),

          // Mengganti ListView.builder dengan Column dan .map
          ...filteredSekolahList.map((sekolah) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SekolahCard(
                namaSekolah: sekolah['nama'],
                telepon: sekolah['telepon'],
                email: sekolah['email'],
                alamat: sekolah['alamat'],
                onKirimEmail: () => _kirimEmail(sekolah['email']),
                onTelepon: () => _telepon(sekolah['telepon']),
                onLihatPeta: () => _lihatPeta(sekolah['alamat']),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
