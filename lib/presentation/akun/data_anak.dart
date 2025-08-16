import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/widgets/dropdown_card.dart';
import 'package:guardian_app/presentation/akun/widgets/anak_card.dart'; // Import the StudentCard widget

class DataAnak extends StatefulWidget {
  const DataAnak({super.key});

  @override
  State<DataAnak> createState() => _DataAnakState();
}

class _DataAnakState extends State<DataAnak> {
  final List<Map<String, dynamic>> _students = [
    {
      "name": "Alya Sintari",
      "status": StudentStatus.alumni,
      "nis": "65133",
      "school": "SMPN 13 Malang",
      "classInfo": "Kelas 9A",
    },
    {
      "name": "Chandra Wijaya",
      "status": StudentStatus.active,
      "nis": "65134",
      "school": "SMPN 13 Malang",
      "classInfo": "Kelas 7A",
    },
    {
      "name": "Sadina Raina",
      "status": StudentStatus.moved,
      "nis": "53122",
      "school": "SMPN 13 Malang",
      "classInfo": "Kelas 9B",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Data Anak"),
        shape: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.5),
                child: DropdownCard(
                  message: 'SMPN 13 Malang',
                  onTap: () {
                    print('Lanjut ke filter sekolah');
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _students.length,
                  itemBuilder: (context, index) {
                    final student = _students[index];
                    return AnakCard(
                      name: student['name'],
                      status: student['status'],
                      nis: student['nis'],
                      school: student['school'],
                      classInfo: student['classInfo'],
                      onPressed: () {
                        // Handle button press
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
