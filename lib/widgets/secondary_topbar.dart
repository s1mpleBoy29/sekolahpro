import 'package:flutter/material.dart';

class SecondaryTopbar extends StatelessWidget {
  final String? onMenuTap;
  final String? itemCategory;
  final Function(String selectedValue)? onActionTap;
  final Function(String, dynamic)? onFilterChanged;
  final List<Widget> slot; // Make slot nullable
  final Color backgroundColor; // New parameter for background color
  final Color lineColor; // New parameter for background color

  // Provide a default value for expandedSlot
  const SecondaryTopbar({
    Key? key,
    this.itemCategory,
    this.onMenuTap,
    this.onActionTap,
    this.onFilterChanged,
    required this.slot,
    this.backgroundColor = Colors.black, // Include backgroundColor parameter
    this.lineColor = Colors.black, // Include backgroundColor parameter
  }) : super(key: key);

  void onTapActionMenu(String selectedValue) async {
    if (onActionTap != null) {
      onActionTap!(selectedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor, // Set background color
        border: Border(
          bottom: BorderSide(
            color: lineColor, // Set the bottom border color
            width: 1.0, // Set the bottom border width
          ),
        ),
      ),
      child: IntrinsicHeight(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...slot,
            ],
          ),
        ),
      ),
    );
  }
}
