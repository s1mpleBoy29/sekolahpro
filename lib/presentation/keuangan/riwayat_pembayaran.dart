import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class RiwayatPembayaran extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pembayaran'),
        shape: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1.0,
          ),
        ),
      ),
      body: Center(
        child: Text('Daftar Riwayat Pembayaran'),
      ),
    );
  }
}
