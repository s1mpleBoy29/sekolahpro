import 'package:flutter/material.dart';
import 'package:guardian_app/theme/custom_text_style.dart';
import 'package:guardian_app/widgets/lottie.dart';
import 'package:guardian_app/core/app_export.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  LoadingScreenState createState() => LoadingScreenState();

  static void showModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: theme.colorScheme.primary,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return const LoadingScreen();
      },
    );
  }

  static void hideModal(BuildContext context) {
    Navigator.pop(context);
  }
}

class LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.primary,
        // backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieWidget(
                  width: 185,
                  height: 185,
                  overlayHeight: 25,
                  overlayWidth: 50,
                  color: theme.colorScheme.primary,
                  path: 'assets/lotties/loading.json'),
              const SizedBox(height: 12),
              Text(
                "Memuat Data ...",
                style: CustomTextStyles.labelMediumLatoWhite,
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}
