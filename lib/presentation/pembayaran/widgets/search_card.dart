import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0,
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
