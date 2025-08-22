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

  void _onDateTapped(DateTime date) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        // Tap pertama untuk start
        _startDate = date;
        _endDate = null;
      } else {
        // Tap kedua untuk end
        if (date.isAfter(_startDate!)) {
          _endDate = date;
        } else {
          // Bila Start dan End sama
          _endDate = _startDate;
          _startDate = date;
        }
      }
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateDropdown(
                      label: 'End Date',
                      date: _endDate,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? _startDate ?? DateTime.now(),
                          firstDate: _startDate ?? DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != _endDate) {
                          setState(() {
                            _endDate = picked;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: _buildCalendarView(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_startDate, _endDate);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7D5C86),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Terapkan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
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
                      ? DateFormat('d-M-yyyy').format(date)
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

  Widget _buildCalendarView() {
    final daysInMonth =
        DateUtils.getDaysInMonth(_displayedMonth.year, _displayedMonth.month);
    final firstDayOfMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    // Offset untuk hari pertama pada bulan ini
    final startingWeekday =
        firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('MMMM yyyy').format(_displayedMonth),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: theme.colorScheme.onSurface)),
            Row(
              children: [
                IconButton(
                    onPressed: _previousMonth,
                    icon: const Icon(Icons.chevron_left)),
                IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Icons.chevron_right)),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
              .map((day) => Text(day,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)))
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount: daysInMonth + startingWeekday,
          itemBuilder: (context, index) {
            if (index < startingWeekday) {
              return Container();
            }
            final dayNumber = index - startingWeekday + 1;
            final currentDate = DateTime(
                _displayedMonth.year, _displayedMonth.month, dayNumber);

            // Determinasi untuk currentDate == selected
            bool isStartDate = _startDate != null &&
                DateUtils.isSameDay(currentDate, _startDate);
            bool isEndDate =
                _endDate != null && DateUtils.isSameDay(currentDate, _endDate);
            bool isInRange = _startDate != null &&
                _endDate != null &&
                currentDate.isAfter(_startDate!) &&
                currentDate.isBefore(_endDate!);

            ThemeData themes = Theme.of(context);

            Color bgColor = Colors.transparent;
            Color textColor = themes.colorScheme.onSurface;

            if (isStartDate || isEndDate) {
              bgColor = themes.colorScheme.primary;
              textColor = Colors.white;
            } else if (isInRange) {
              bgColor = themes.colorScheme.secondary.withOpacity(0.2);
            }

            return InkWell(
              // This is changed
              onTap: () => _onDateTapped(currentDate),
              customBorder: const CircleBorder(),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  dayNumber.toString(),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: (isStartDate || isEndDate)
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
