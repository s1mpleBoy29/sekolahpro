import 'package:flutter/material.dart';

// Enum to represent the student's status, making it easy to manage styles.
enum StudentStatus {
  active,
  alumni,
  moved,
}

/// A widget that displays student information and status, styled to match the provided image.
class AnakCard extends StatelessWidget {
  final String school;
  final String name;
  final String nis; // Student Identification Number
  final String classInfo; // Student's class information
  final StudentStatus status;
  final VoidCallback onPressed;

  const AnakCard({
    super.key,
    required this.school,
    required this.name,
    required this.nis,
    required this.classInfo,
    required this.status,
    required this.onPressed,
  });

  // Helper method to get the button text based on the status.
  String _getButtonText() {
    switch (status) {
      case StudentStatus.active:
        return 'Aktif';
      case StudentStatus.alumni:
        return 'Alumni';
      case StudentStatus.moved:
        return 'Pindah';
    }
  }

  // Helper method to get the button's text and border color based on the status.
  Color _getButtonColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (status) {
      case StudentStatus.active:
        return Colors.green;
      case StudentStatus.alumni:
      case StudentStatus.moved:
        return theme.colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = _getButtonColor(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  school,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$nis | $classInfo',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: buttonColor,
              side: BorderSide(color: buttonColor, width: 1.2),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              fixedSize: const Size(70, 30),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              _getButtonText(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
