import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class BayarSatu extends StatefulWidget {
  @override
  _BayarSatuState createState() => _BayarSatuState();
}

class _BayarSatuState extends State<BayarSatu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran Satu"),
      ),
      body: Center(
        child: Text("Isi Pembayaran Satu"),
      ),
    );
  }
}
