import 'package:flutter/material.dart';
import 'package:guardian_app/presentation/agenda/agenda.dart';
import 'package:guardian_app/presentation/akun/akun.dart';
import 'package:guardian_app/presentation/akun/edit_profile.dart';
import 'package:guardian_app/presentation/keuangan/detailpembayaran.dart';
import 'package:guardian_app/presentation/info_sekolah/info_sekolah.dart';
import 'package:guardian_app/presentation/keuangan/keuangan.dart';
import 'package:guardian_app/presentation/notifikasi/detailNotifikasi.dart';
import 'package:guardian_app/presentation/notifikasi/notifikasi.dart';
import 'package:guardian_app/presentation/ubah_password.dart';

import '../presentation/home/home.dart';
import '../presentation/login_screen.dart';
import '../presentation/pilihanak/pilihanak.dart';
import '../presentation/pembayaran/bayarsatu.dart';
import '../presentation/pembayaran/bayardua.dart';
import '../presentation/pembayaran/bayartiga.dart';
import '../presentation/agenda/detailagenda.dart';
import '../presentation/keuangan/riwayat_pembayaran.dart';
import '../presentation/akun/data_anak.dart';

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
  static const String riwayatPembayaran = '/riwayat_pembayaran';
  static const String akunScreen = '/akun_screen';
  static const String editProfieScreen = '/edit_profile_screen';
  static const String ubahPasswordScreen = '/ubah_password_screen';
  static const String dataAnakScreen = '/data_anak_screen';
  static const String infoSekolahScreen = '/info_sekolah_screen';
  static const String detailNotifikasiScreen = '/detail_notifikasi_screen';
  static Map<String, WidgetBuilder> routes = {
    loginScreen: (context) => const LoginScreen(),
    homeScreen: (context) => const HomeScreen(),
    agendaScreen: (context) => const AgendaScreen(),
    DetailAgendaScreen: (context) => const DetailAgenda(),
    NotifikasiScreen: (context) => const NotificationListScreen(),
    pilihAnakScreen: (context) => const PilihAnakScreen(
      postSelectionAction: PostSelectionAction.navigateToHome,
    ),
    bayarSatuScreen: (context) => const BayarSatuScreen(),
    bayarDuaScreen: (context) => const BayarDuaScreen(),
    bayarTigaScreen: (context) => const BayarTigaScreen(),
    keuanganScreen: (context) => const KeuanganScreen(),
    paymentDetailPage: (context) => const PaymentDetailPage(),
    riwayatPembayaran: (context) => RiwayatPembayaran(),
    akunScreen: (context) => const AkunScreen(),
    editProfieScreen: (context) => const EditProfileScreen(),
    ubahPasswordScreen: (context) => const UbahPasswordScreen(),
    dataAnakScreen: (context) => const DataAnak(),
    infoSekolahScreen: (context) => const InfoSekolahScreen(),
    detailNotifikasiScreen: (context) => const NotificationDetailScreen(),
  };
}
