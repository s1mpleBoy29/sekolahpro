import 'package:flutter/material.dart';
import 'package:guardian_app/presentation/agenda.dart';

import '../presentation/home/home.dart';
import '../presentation/login.dart';
import '../presentation/pilihanak/pilihanak.dart';
//other imports

class AppRoutes {
  static const String loginScreen = '/login_screen';
  static const String homeScreen = '/home_screen';
  static const String agendaScreen = '/agenda_screen';
  static const String pilihAnakScreen = '/pilih_anak_screen';
  static Map<String, WidgetBuilder> routes = {
    loginScreen: (context) => LoginScreen(),
    homeScreen: (context) => HomeScreen(),
    agendaScreen: (context) => AgendaScreen(),
    pilihAnakScreen: (context) => PilihAnakScreen(),
  };
}
