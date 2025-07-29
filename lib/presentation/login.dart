import 'package:flutter/material.dart';
import 'package:guardian_app/widgets/custom_elevated_button.dart';
import 'package:guardian_app/widgets/custom_outlined_button.dart';
import 'package:guardian_app/widgets/custom_text_form_field.dart';
import 'package:guardian_app/widgets/loading.dart';

import 'package:guardian_app/core/app_export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginPageScreen createState() => LoginPageScreen();
}

class LoginPageScreen extends State<LoginScreen> {
  TextEditingController enterPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  String token = '';
  bool _obscurePassword = true;

  void _togglePasswordView() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  void initState() {
    super.initState();

    isLoading.addListener(() {
      if (isLoading.value) {
        LoadingScreen.showModal(context);
      } else {
        LoadingScreen.hideModal(context);
      }
    });
  }

  void onTapMasuk(BuildContext context) async {
    Navigator.pushNamed(
      context,
      AppRoutes.pilihanakScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            top: -50,
            child: Image.asset(
              'assets/images/blur.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 200,
                        height: 200,
                      ),
                    ],
                  ),
                  Text(
                    'Sign in to your\nAccount',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    'Enter your email and password to log in',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Email Field
                  _buildPhoneNumberSection(context),
                  const SizedBox(height: 16),
                  // Password Field
                  _buildPasswordSection(context),
                  const SizedBox(height: 12),
                  // Remember me + Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Lupa Password?",
                        style: CustomTextStyles.labelMediumPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Log In Button
                  CustomElevatedButton(
                    text: "Log In",
                    onPressed: () => onTapMasuk(context),
                    height: 48,
                  ),
                  const SizedBox(height: 24),
                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Or",
                          style: TextStyle(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Continue with Google
                  CustomOutlinedButton(
                    text: " Continue with Google",
                    height: 48,
                    buttonTextStyle: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    leftIcon: Image.asset(
                      'assets/images/google_logo.svg.webp',
                      height: 20,
                    ),
                    onPressed: () {
                      // onTapBelumPunyaAkun(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomOutlinedButton(
                    text: " Continue with Facebook",
                    height: 48,
                    buttonTextStyle: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    leftIcon: Image.asset(
                      'assets/images/facebook_logo.png',
                      height: 20,
                    ),
                    onPressed: () {
                      // onTapBelumPunyaAkun(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  FocusNode inputPhone = FocusNode();
  Widget _buildPhoneNumberSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 1),
        //   child: Text(
        //     "Email",
        //     style: TextStyle(
        //       fontSize: 16,
        //       color: theme.colorScheme.onPrimaryContainer,
        //     ),
        //   ),
        // ),
        const SizedBox(height: 6),
        CustomTextFormField(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          borderDecoration: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 0,
            ),
          ),
          fillColor: theme.colorScheme.secondaryContainer,
          textStyle: TextStyle(
            color: theme.colorScheme.onPrimaryContainer,
          ),
          controller: enterPhoneController,
          focusNode: inputPhone,
          hintText: "Masukin email mu",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email tidak boleh kosong';
            }
            return null;
          },
          onTapOutside: (value) {
            inputPhone.unfocus();
          },
        ),
      ],
    );
  }

  FocusNode inputPassword = FocusNode();
  Widget _buildPasswordSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 1),
        //   child: Text(
        //     "Password",
        //     style: TextStyle(
        //       fontSize: 16,
        //       color: theme.colorScheme.onPrimaryContainer,
        //     ),
        //   ),
        // ),
        const SizedBox(height: 6),
        CustomTextFormField(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          borderDecoration: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 0,
            ),
          ),
          fillColor: theme.colorScheme.secondaryContainer,
          textStyle: TextStyle(
            color: theme.colorScheme.onPrimaryContainer,
          ),
          controller: passwordController,
          obscureText: _obscurePassword,
          suffix: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: _togglePasswordView,
          ),
          focusNode: inputPassword,
          hintText: "Masukin password mu",
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password tidak boleh kosong';
            }
            return null;
          },
          onTapOutside: (value) {
            inputPassword.unfocus();
          },
          onEditingComplete: () {
            // print('debug');
            inputPassword.unfocus();
            onTapMasuk(context);
          },
        ),
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
