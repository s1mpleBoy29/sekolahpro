import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart'; // Pastikan ini mengimpor theme_helper.dart atau appTheme/theme

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSearchTap;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Cari nama, kelas, dll',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: appTheme.blueGray50, // <--- PERUBAHAN DI SINI: Menggunakan warna abu-abu
        borderRadius: BorderRadius.circular(8.0), // Sudut membulat
        border: Border.all(
          color: theme.colorScheme.outlineVariant, // Warna border tetap sama
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontSize: 16,
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
          GestureDetector(
            onTap: onSearchTap ?? () {
              if (controller != null && onSubmitted != null) {
                onSubmitted!(controller!.text);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.search,
                color: theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}