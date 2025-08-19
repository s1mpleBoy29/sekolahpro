import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:intl/intl.dart';

class DateFilter extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final VoidCallback onBack;
  final Function(DateTime?, DateTime?) onApply;

  const DateFilter({
    Key? key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onBack,
    required this.onApply,
  }) : super(key: key);

  @override
  State<DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  DateTime? _startDate;
  DateTime? _endDate;
  // Default adalah bulan saat ini
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    // Default adalah hari ini
    _displayedMonth = widget.initialStartDate ?? DateTime.now();
  }

  // Navigasi untuk bulan sebelumnya
  void _previousMonth() {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  // Navigasi untuk bulan berikutnya.
  void _nextMonth() {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        key: const ValueKey('dateFilter'),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Tanggal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onBack,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildDateDropdown(
                      label: 'Start Date',
                      date: _startDate,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != _startDate) {
                          setState(() {
                            _startDate = picked;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateDropdown({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date != null
                      ? DateFormat('d MMM yyyy').format(date)
                      : 'Pilih Tanggal',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: theme.colorScheme.outline),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
