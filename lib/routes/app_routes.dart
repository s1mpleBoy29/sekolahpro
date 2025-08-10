import 'package:flutter/material.dart';
import 'package:guardian_app/presentation/agenda/agenda.dart';
import 'package:guardian_app/presentation/detailpembayaran.dart';
import 'package:guardian_app/presentation/keuangan/keuangan.dart';
import 'package:guardian_app/presentation/notifikasi/notifikasi.dart';

import '../presentation/home/home.dart';
import '../presentation/login.dart';
import '../presentation/pilihanak/pilihanak.dart';
import '../presentation/pembayaran/bayarsatu.dart';
import '../presentation/pembayaran/bayardua.dart';
import '../presentation/pembayaran/bayartiga.dart';
import '../presentation/detailagenda.dart';

class AppRoutes {
  static const String loginScreen = '/login_screen';
  static const String homeScreen = '/home_screen';
  static const String agendaScreen = '/agenda_screen';
  static const String pilihAnakScreen = '/pilih_anak_screen';
  static const String bayarSatuScreen = '/bayar_satu_screen';
  static const String bayarDuaScreen = '/bayar_dua_screen';
  static const String bayarTigaScreen = '/bayar_tiga_screen';
  static const String DetailAgendaScreen = '/detail_agenda_screen';
  static const String NotifikasiScreen = '/notifikasi_screen';
  static const String keuanganScreen = '/keuangan_screen';
    static const String paymentDetailPage = '/detail_pembayaran';
  static Map<String, WidgetBuilder> routes = {
    loginScreen: (context) => LoginScreen(),
    homeScreen: (context) => HomeScreen(),
    agendaScreen: (context) => AgendaScreen(),
    DetailAgendaScreen: (context) => DetailAgenda(),
    NotifikasiScreen: (context) => NotificationPage(),
    pilihAnakScreen: (context) => PilihAnakScreen(),
    bayarSatuScreen: (context) => BayarSatuScreen(),
    bayarDuaScreen: (context) => BayarDuaScreen(),
    bayarTigaScreen: (context) => BayarTigaScreen(),
    keuanganScreen: (context) => KeuanganScreen(),
    paymentDetailPage: (context) => PaymentDetailPage()
  };
}
