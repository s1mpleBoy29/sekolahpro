import 'dart:io';
import 'package:guardian_app/core/providers/config_provider.dart';
import 'package:guardian_app/core/providers/home_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:guardian_app/app_state.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/core/providers/auth_provider.dart';
import 'package:guardian_app/core/providers/student_provider.dart';
import 'package:guardian_app/core/utils/config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    try {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      if (Platform.isIOS) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        );
      } else if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        );
      } else {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  AppState().appVersion = packageInfo.version;

  await ConfigService.load();
  await dotenv.load(fileName: ".env");

  final authProvider = AuthProvider();
  await authProvider.loadToken();

  // Baca theme dari SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  ThemeHelper().changeTheme('primary');
  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConfigProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const _MyApp(),
    ),
  );
}

class _MyApp extends StatefulWidget {
  const _MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp> with WidgetsBindingObserver {
  late Future<String> _initialRouteFuture;
  String? initialMessage;

  @override
  void initState() {
    super.initState();
    _initialRouteFuture = _checkStoredUser();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    bool isUserLogin = AppState().token.isNotEmpty ? true : false;

    if (AppState().isSplash == false) {
      if (state == AppLifecycleState.resumed) {
        if (isUserLogin) {
          setState(() {
            // getUserData.callCustomerDatas();
            AppState().prevPage = navigatorKey.currentState!.context.toString();
            // Navigator.pushReplacementNamed(navigatorKey.currentState!.context, AppRoutes.splashScreen);
            // Navigator.pushNamed(
            //     navigatorKey.currentState!.context, AppRoutes.splashScreen);
          });
        } else {
          AppState().prevPage = navigatorKey.currentState!.context.toString();
          // Navigator.pushReplacementNamed(navigatorKey.currentState!.context, AppRoutes.splashScreen);
          // Navigator.pushNamed(
          //     navigatorKey.currentState!.context, AppRoutes.splashScreen);
        }
      }
    }
  }

  Future<String> _checkStoredUser() async {
    // debug mode
    // return AppRoutes.loginScreen;
    // return AppRoutes.deleteAccount;

    // me myMe = me();
    // if (await myMe.checkStoredUser()) {
    // return AppRoutes.splashScreen;
    // }
    return AppRoutes.loginScreen;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _initialRouteFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Menampilkan loading indicator jika sedang menunggu hasil
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Menampilkan pesan error jika terjadi error
          return Text('Error: ${snapshot.error}');
        } else {
          // Membangun aplikasi dengan initialRoute berdasarkan hasil
          return MaterialApp(
            theme: theme,
            title: 'Guardian App',
            debugShowCheckedModeBanner: false,
            initialRoute: snapshot.data!,
            navigatorKey: navigatorKey,
            routes: AppRoutes.routes,
          );
        }
      },
    );

    // return MaterialApp(
    //   title: 'Guardian App',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   initialRoute: AppRoutes.loginScreen,
    //   routes: AppRoutes.routes,
    // );
  }
}
