import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:guardian_app/core/actions/config_action.dart';
import 'package:guardian_app/core/actions/student_action.dart';
import 'package:guardian_app/core/providers/config_provider.dart';
import 'package:guardian_app/core/providers/student_provider.dart';
import 'package:guardian_app/core/utils/config.dart';
import 'package:guardian_app/data/models/student.dart';
import 'package:guardian_app/theme/theme_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  String _errorMessage = '';
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchConfig();
    await _fetchStudent();
    // if (ConfigService.isUsingOutlet) {
    //   await checkOutlet();
    //   await checkRoles();
    // } else {
    //   // await _fetchModeOfPayment();
    // }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchConfig() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final configProvider =
          Provider.of<ConfigProvider>(context, listen: false);
      // Parallel execution of API calls
      final results = await Future.wait<dynamic>([
        ConfigAction.getConfig(),
      ]);

      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Sesi anda telah berakhir. Silakan login kembali.'),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pushReplacementNamed(context, '/login_screen');
      }

      if (results.isNotEmpty) {
        final config = results[0] as Map<String, dynamic>;
        await configProvider.saveConfig(config);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = _parseErrorMessage(e);
      });
    }
  }

  Future<void> _fetchStudent() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final provider = Provider.of<StudentProvider>(context, listen: false);
      // Parallel execution of API calls
      final results = await Future.wait<dynamic>([
        StudentAction.getStudents(1000, 0, ''),
      ]);

      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Sesi anda telah berakhir. Silakan login kembali.'),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pushReplacementNamed(context, '/login_screen');
      }

      final student = results[0] as List<Student>;
      await provider.saveStudents(student);

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/pilih_anak_screen', arguments: {
        'postSelectionAction': 'navigateToHome',
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = _parseErrorMessage(e);
      });
    }
  }

  String _parseErrorMessage(dynamic error) {
    if (error.toString().contains('No internet')) {
      return 'Tidak ada koneksi internet. Periksa jaringan Anda.';
    } else if (error.toString().contains('timeout')) {
      return 'Waktu koneksi habis. Silakan coba lagi.';
    } else if (error.toString().contains('connection')) {
      return 'Gagal terhubung ke server. Periksa koneksi Anda.';
    }
    return 'Terjadi kesalahan tidak terduga. Silakan coba lagi.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _opacityAnimation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ConfigService.logo,
                    width: 250,
                  ),
                  const SizedBox(height: 40),
                  _isLoading ? _buildLoadingState() : _buildErrorState(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Column(
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Memuat data...',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.shade50,
          ),
          child: Icon(
            Icons.error_outline_rounded,
            color: Colors.red.shade800,
            size: 36,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Gagal Memuat Data',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
