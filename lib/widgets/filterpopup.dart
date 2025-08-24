import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:guardian_app/widgets/date_filter.dart';

// Enum untuk menentukan halaman pemanggil
enum FilterPage {
  keuangan,
  agenda,
}

// Data dummy untuk filter keuangan
enum KeuanganFilterStatus {
  semua,
  lunas,
  belumLunas,
  tenggat,
}

// Data dummy untuk filter agenda
enum AgendaFilterPengirim {
  waliKelas5A,
  guruOlahraga,
  adminSekolah,
  semua,
}

class FilterPopup extends StatefulWidget {
  final FilterPage currentPage;
  final Function(Map<String, dynamic>) onApplyFilter;

  const FilterPopup({
    Key? key,
    required this.currentPage,
    required this.onApplyFilter,
  }) : super(key: key);

  @override
  State<FilterPopup> createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  String selectedTahunAjaran = '2025/2026';
  List<String> tahunAjaranList = ['2024/2025', '2025/2026', '2026/2027'];
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showDateFilter = false;

  KeuanganFilterStatus _selectedKeuanganStatus = KeuanganFilterStatus.semua;
  AgendaFilterPengirim _selectedAgendaPengirim = AgendaFilterPengirim.semua;

  String get _dateFilterText {
    if (_startDate == null && _endDate == null) {
      return 'Hari Ini';
    }
    final format = DateFormat('d MMM yyyy');
    if (_startDate != null && _endDate == null) {
      return format.format(_startDate!);
    }
    if (_startDate != null && _endDate != null) {
      if (DateUtils.isSameDay(_startDate, _endDate)) {
        return format.format(_startDate!);
      }
      return '${format.format(_startDate!)} - ${format.format(_endDate!)}';
    }
    return 'Pilih Tanggal';
  }

  void _onApply() {
    final Map<String, dynamic> filters = {
      'tahun_ajaran': selectedTahunAjaran,
      'tanggal_mulai': _startDate,
      'tanggal_akhir': _endDate,
    };

    if (widget.currentPage == FilterPage.keuangan) {
      filters['status_pembayaran'] = _selectedKeuanganStatus;
    } else if (widget.currentPage == FilterPage.agenda) {
      filters['pengirim'] = _selectedAgendaPengirim;
    }

    widget.onApplyFilter(filters);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _showDateFilter
            ? DateFilter(
                key: const ValueKey('dateFilter'),
                initialStartDate: _startDate,
                initialEndDate: _endDate,
                onBack: () {
                  setState(() {
                    _showDateFilter = false;
                  });
                },
                onApply: (newStartDate, newEndDate) {
                  setState(() {
                    _startDate = newStartDate;
                    _endDate = newEndDate;
                    _showDateFilter = false;
                  });
                },
              )
            : _buildMainFilter(),
      ),
    );
  }

  Widget _buildMainFilter() {
    return Column(
      key: const ValueKey('mainFilter'),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Lainnya',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildFilterSection(
              title: 'Anak',
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.people_alt_outlined, color: Color(0xFF7D5C86)),
                    SizedBox(width: 8),
                    Text(
                      '3 Anak Dipilih',
                      style: TextStyle(
                        color: Color(0xFF7D5C86),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildFilterSection(
              title: 'Tanggal',
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showDateFilter = true;
                  });
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: Color(0xFF7D5C86)),
                      const SizedBox(width: 8),
                      Text(
                        _dateFilterText,
                        style: const TextStyle(
                          color: Color(0xFF7D5C86),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.currentPage == FilterPage.keuangan)
              _buildKeuanganFilters(),
            if (widget.currentPage == FilterPage.agenda)
              _buildAgendaFilters(),
            _buildFilterSection(
              title: 'Tahun Ajaran',
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedTahunAjaran,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Color(0xFF7D5C86)),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    items: tahunAjaranList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTahunAjaran = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _onApply,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7D5C86),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Terapkan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildKeuanganFilters() {
    return _buildFilterSection(
      title: 'Status Pembayaran',
      child: DropdownButtonFormField<KeuanganFilterStatus>(
        value: _selectedKeuanganStatus,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF7D5C86)),
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        items: KeuanganFilterStatus.values.map((status) {
          String statusText = '';
          switch (status) {
            case KeuanganFilterStatus.semua:
              statusText = 'Semua';
              break;
            case KeuanganFilterStatus.lunas:
              statusText = 'Lunas';
              break;
            case KeuanganFilterStatus.belumLunas:
              statusText = 'Belum Lunas';
              break;
            case KeuanganFilterStatus.tenggat:
              statusText = 'Tenggat';
              break;
          }
          return DropdownMenuItem<KeuanganFilterStatus>(
            value: status,
            child: Text(statusText),
          );
        }).toList(),
        onChanged: (KeuanganFilterStatus? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedKeuanganStatus = newValue;
            });
          }
        },
      ),
    );
  }

  Widget _buildAgendaFilters() {
    return _buildFilterSection(
      title: 'Pengirim',
      child: DropdownButtonFormField<AgendaFilterPengirim>(
        value: _selectedAgendaPengirim,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF7D5C86)),
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        items: AgendaFilterPengirim.values.map((pengirim) {
          String pengirimText = pengirim.name.replaceAll('_', ' ').toUpperCase();
          return DropdownMenuItem<AgendaFilterPengirim>(
            value: pengirim,
            child: Text(pengirimText),
          );
        }).toList(),
        onChanged: (AgendaFilterPengirim? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedAgendaPengirim = newValue;
            });
          }
        },
      ),
    );
  }
}