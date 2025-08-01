import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class BayarTigaScreen extends StatefulWidget {
  @override
  _BayarTigaState createState() => _BayarTigaState();
}

class _BayarTigaState extends State<BayarTigaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran Tiga"),
      ),
      body: Center(
        child: Text("Isi Pembayaran Tiga"),
      ),
    );
  }
}
