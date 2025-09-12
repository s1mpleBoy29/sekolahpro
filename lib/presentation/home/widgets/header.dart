import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class Header extends StatelessWidget {
  final String greeting; // contoh: "Halo, Ibu Yulia"
  final String childName; // contoh: "Candra Wijaya"
  final String schoolName; // contoh: "SDN 13 Malang"
  final VoidCallback? onDropdownTap;
  final VoidCallback? onTapNotification;

  const Header({
    super.key,
    required this.greeting,
    required this.childName,
    required this.schoolName,
    this.onDropdownTap,
    this.onTapNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // 👉 background putih
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Kiri (Greeting + Dropdown Anak)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Lihat data untuk:",
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onDropdownTap,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "$childName · $schoolName",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_drop_down,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bagian Kanan (QR / Share icon)
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              size: 28,
            ),
            onPressed: onTapNotification,
          ),
        ],
      ),
    );
  }
}
