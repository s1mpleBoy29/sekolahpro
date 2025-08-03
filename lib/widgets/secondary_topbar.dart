import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SecondaryTopbar extends StatelessWidget {
  final String? onMenuTap;
  final String? itemCategory;
  final Function(String selectedValue)? onActionTap;
  final Function(String, dynamic)? onFilterChanged;
  final List<Widget> slot;
  final Color backgroundColor;
  final Color lineColor;
  final String title;
  final Color titleColor;

  const SecondaryTopbar({
    Key? key,
    this.itemCategory,
    this.onMenuTap,
    this.onActionTap,
    this.onFilterChanged,
    required this.slot,
    this.backgroundColor = Colors.black,
    this.lineColor = Colors.black,
    this.title = '',
    this.titleColor = Colors.white,
  }) : super(key: key);

  void onTapActionMenu(String selectedValue) async {
    if (onActionTap != null) {
      onActionTap!(selectedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If slot is empty, use simple layout with title and filter icon
    if (slot.isEmpty) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: lineColor,
              width: 1.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Title text centered
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              // Filter icon on the right
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    onTapActionMenu('filter');
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      LucideIcons.filter,
                      color: titleColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // If slot is not empty, use original layout with slots
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: lineColor,
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Use slots if provided
            ...slot,
            
            // Filter icon (always show if there are slots)
            if (slot.isNotEmpty)
              InkWell(
                onTap: () {
                  onTapActionMenu('filter');
                },
                child: Icon(
                  LucideIcons.filter,
                  color: titleColor,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
