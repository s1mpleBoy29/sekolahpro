import 'package:flutter/material.dart';
import 'package:guardian_app/presentation/agenda.dart';

import '../presentation/home.dart';
import '../presentation/login.dart';
import '../presentation/pilihanak/pilihanak.dart';
class AppRoutes {
  static const String loginScreen = '/login_screen';
  static const String homeScreen = '/home_screen';
  static const String agendaScreen = '/agenda_screen';
  static const String pilihanakScreen = '/pilihanak_screen';
  static Map<String, WidgetBuilder> routes = {
    loginScreen: (context) => LoginScreen(),
    homeScreen: (context) => HomeScreen(),
    agendaScreen: (context) => AgendaScreen(),
    pilihanakScreen:(context) => PilihAnakScreen()
  };
}
