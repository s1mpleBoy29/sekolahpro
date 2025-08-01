import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class BayarDuaScreen extends StatefulWidget {
  @override
  _BayarDuaState createState() => _BayarDuaState();
}

class _BayarDuaState extends State<BayarDuaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran Dua"),
      ),
      body: Center(
        child: Text("Isi Pembayaran Dua"),
      ),
    );
  }
}
