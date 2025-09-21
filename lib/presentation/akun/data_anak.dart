import 'package:flutter/material.dart';
import 'package:guardian_app/core/providers/student_provider.dart';
import 'package:guardian_app/data/models/student.dart';
import 'package:guardian_app/widgets/ad_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guardian_app/data/api/ad.dart';
import 'package:guardian_app/data/models/ad.dart';
import 'dart:async';

class dataAnakScreen extends StatefulWidget {
  const dataAnakScreen({
    super.key,
  });

  @override
  _DataAnakScreenState createState() => _DataAnakScreenState();
}

class _DataAnakScreenState extends State<dataAnakScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Student> allChildren = [];
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
      if (mounted) {
        setState(() {
          _currentAdIndex = (_currentAdIndex + 1) % _adList.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _adTimer?.cancel();
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
    if (mounted) {
      setState(() {
        allChildren = students;
      });
    }
  }

  void _onSelectChild(Student childData) {
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    studentProvider.setSelectedStudent(childData);

    if (mounted) {
      Navigator.pop(context, childData);
    }
  }

  // Widget untuk kartu siswa tanpa status
  Widget _buildStudentCard(Student student) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.schoolName,
              style: const TextStyle(
                color: Color(0xFF757575),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              student.fullName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${student.gradeName}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF757575),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double adCardEstimatedHeight = 120.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Data Anak'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SMPN 13 Malang',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await loadStudent();
                      },
                      child: allChildren.isEmpty
                          ? const Center(
                              child: Text('Tidak ada anak ditemukan.'),
                            )
                          : ListView.builder(
                              itemCount: allChildren.length,
                              itemBuilder: (context, index) {
                                final childData = allChildren[index];
                                return _buildStudentCard(childData);
                              },
                            ),
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