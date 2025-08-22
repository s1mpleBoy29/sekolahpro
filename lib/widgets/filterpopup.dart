import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:guardian_app/widgets/date_filter.dart';

class FilterPopup extends StatefulWidget {
  const FilterPopup({Key? key}) : super(key: key);

  @override
  State<FilterPopup> createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  String selectedTahunAjaran = '2025/2026';
  List<String> tahunAjaranList = ['2024/2025', '2025/2026', '2026/2027'];

  DateTime? _startDate;
  DateTime? _endDate;

  bool _showDateFilter = false;

  String get _dateFilterText {
    if (_startDate == null && _endDate == null) {
      return 'Hari Ini';
    }
    final format = DateFormat('d MMM yyyy');
    if (_startDate != null && _endDate == null) {
      return format.format(_startDate!);
    }
    if (_startDate != null && _endDate != null) {
      // Jika tanggal mulai dan tanggal akhir adalah hari yang sama, maka tunjukkan hari itu
      if (DateUtils.isSameDay(_startDate, _endDate)) {
        return format.format(_startDate!);
      }
      // Jika tidak, tunjukkan rentang tanggal
      return '${format.format(_startDate!)} - ${format.format(_endDate!)}';
    }
    return 'Pilih Tanggal';
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
                // Callback to return to the main filter.
                onBack: () {
                  setState(() {
                    _showDateFilter = false;
                  });
                },
                // Callback to apply the selected dates from the DateFilter widget.
                onApply: (newStartDate, newEndDate) {
                  setState(() {
                    _startDate = newStartDate;
                    _endDate = newEndDate;
                    _showDateFilter = false; // Switch back to the main view
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

            // Anak Filter
            const Text(
              'Anak',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
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
            const SizedBox(height: 16),

            // Tanggal Filter
            const Text(
              'Tanggal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
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
                    // The text is now dynamic based on the selected dates.
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
            const SizedBox(height: 16),

            // Tahun Ajaran Filter
            const Text(
              'Tahun Ajaran',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
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
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
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
}
