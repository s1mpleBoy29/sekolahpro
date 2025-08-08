import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class DeskripsiOpsional extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;

  const DeskripsiOpsional({
    super.key,
    required this.controller,
    this.title = "Keterangan Tambahan (opsional)",
    this.hintText = 'Keterangan . . .',
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
              children: <TextSpan>[
                const TextSpan(
                  text: 'Keterangan Tambahan ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '(opsional)',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: theme.colorScheme.outline.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
        TextField(
          controller: controller,
          textAlign: TextAlign.start,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide:
                  BorderSide(color: theme.colorScheme.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
