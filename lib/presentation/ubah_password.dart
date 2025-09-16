import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/data/api/login.dart';
import 'package:guardian_app/widgets/custom_elevated_button.dart';
import 'package:guardian_app/widgets/custom_text_form_field.dart';

class UbahPasswordScreen extends StatefulWidget {
  const UbahPasswordScreen({Key? key}) : super(key: key);

  @override
  UbahPasswordPageScreen createState() => UbahPasswordPageScreen();
}

class UbahPasswordPageScreen extends State<UbahPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  String? passwordOld;
  String? passwordNew;
  String? passwordConfirm;

  bool _isLoading = false;

  final ValueNotifier<bool> isChanged = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    passwordOldController.addListener(checkChanged);
    passwordNewController.addListener(checkChanged);
    passwordConfirmController.addListener(checkChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    constollerDispose();
    isChanged.dispose();
    super.dispose();
  }

  void checkChanged() {
    String passwordOld = passwordOldController.text;
    String passwordNew = passwordNewController.text;
    String passwordConfirm = passwordConfirmController.text;

    final hasChanged =
        passwordOld != '' || passwordNew != '' || passwordConfirm != '';

    if (hasChanged != isChanged.value) {
      isChanged.value = hasChanged;
    }
  }

  void unfocusAll() {
    passwordOldFocus.unfocus();
    passwordNewFocus.unfocus();
    passwordConfirmFocus.unfocus();
  }

  void constollerDispose() {
    passwordOldController.dispose();
    passwordNewController.dispose();
    passwordConfirmController.dispose();
  }

  void clearAll() {
    passwordOldController.clear();
    passwordNewController.clear();
    passwordConfirmController.clear();
  }

  void onChangePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final authService = AuthService();
        final loginResponse = await authService.changePassword(
          oldPassword: passwordOldController.text,
          newPassword: passwordNewController.text,
        );

        if (kDebugMode) {
          print("DEBUG: loginResponse = $loginResponse");
        }

        if (loginResponse.containsKey('message')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loginResponse['message']),
              backgroundColor: appTheme.green600,
            ),
          );
          clearAll();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: appTheme.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        unfocusAll();
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surfaceContainer,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          title: const Text(
            'Ubah Password',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          shape: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.akunScreen);
            },
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kata sandi Anda harus memiliki panjang minimal 6 karakter dan harus menyertakan kombinasi angka, huruf, serta karakter khusus seperti (!@#\$%)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  SizedBox(height: 16.v),
                  Text(
                    'Password Lama',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _inputPasswordOld(context),
                  const SizedBox(height: 16),
                  Text(
                    'Password Baru',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _inputPasswordNew(context),
                  const SizedBox(height: 16),
                  Text(
                    'Konfirmasi Password Baru',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _inputPasswordConfirm(context),
                  SizedBox(height: 24.v),
                  ValueListenableBuilder<bool>(
                    valueListenable: isChanged,
                    builder: (context, changed, _) {
                      return CustomElevatedButton(
                        text: "UBAH PASSWORD",
                        onPressed: changed
                            ? () {
                                onChangePassword();
                              }
                            : null, // disable kalau tidak ada perubahan
                        height: 48,
                        buttonStyle: changed
                            ? CustomButtonStyles.primaryButton
                            : CustomButtonStyles.disabledButton,
                        buttonTextStyle:
                            CustomTextStyles.labelLargeLatoOnPrimary.copyWith(
                          fontSize: 12.fSize,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TextEditingController passwordOldController = TextEditingController();
FocusNode passwordOldFocus = FocusNode();
bool obscurePasswordOld = true;
Widget _inputPasswordOld(BuildContext context) {
  return CustomTextFormField(
    autofocus: false,
    controller: passwordOldController,
    focusNode: passwordOldFocus,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    borderDecoration: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: appTheme.gray300,
        width: 0,
      ),
    ),
    obscureText: obscurePasswordOld,
    suffix: IconButton(
      icon: Icon(
        obscurePasswordOld ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: () {
        obscurePasswordOld = !obscurePasswordOld;
        (context as Element).markNeedsBuild();
      },
    ),
    fillColor: theme.colorScheme.surface,
    textStyle: TextStyle(
      color: theme.colorScheme.onPrimaryContainer,
    ),
    hintText: "Masukin password lama",
    // hintStyle: CustomTextStyles.bodySmallGray,
    textInputAction: TextInputAction.done,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'password lama tidak boleh kosong';
      }
      return null;
    },
  );
}

TextEditingController passwordNewController = TextEditingController();
FocusNode passwordNewFocus = FocusNode();
bool obscurePasswordNew = true;
Widget _inputPasswordNew(BuildContext context) {
  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password baru wajib diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    final regex = RegExp(r'^(?=.*[0-9!@#\$%^&*(),.?":{}|<>]).+$');
    if (!regex.hasMatch(value)) {
      return 'Password harus mengandung angka atau karakter khusus';
    }
    return null;
  }

  return CustomTextFormField(
    autofocus: false,
    controller: passwordNewController,
    focusNode: passwordNewFocus,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    borderDecoration: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: appTheme.gray300,
        width: 0,
      ),
    ),
    obscureText: obscurePasswordNew,
    suffix: IconButton(
      icon: Icon(
        obscurePasswordNew ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: () {
        obscurePasswordNew = !obscurePasswordNew;
        (context as Element).markNeedsBuild();
      },
    ),
    fillColor: theme.colorScheme.surface,
    textStyle: TextStyle(
      color: theme.colorScheme.onPrimaryContainer,
    ),
    hintText: "Masukin password baru",
    // hintStyle: CustomTextStyles.bodySmallGray,
    textInputAction: TextInputAction.done,
    validator: validateNewPassword,
    onTapOutside: (value) {
      // inputPassword.unfocus();
    },
    onEditingComplete: () {},
  );
}

TextEditingController passwordConfirmController = TextEditingController();
FocusNode passwordConfirmFocus = FocusNode();
bool obscurePasswordConfirm = true;
Widget _inputPasswordConfirm(BuildContext context) {
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }
    if (value != passwordNewController.text) {
      return 'Konfirmasi password tidak sama';
    }
    return null;
  }

  return CustomTextFormField(
    autofocus: false,
    controller: passwordConfirmController,
    focusNode: passwordConfirmFocus,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    borderDecoration: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: appTheme.gray300,
        width: 0,
      ),
    ),
    obscureText: obscurePasswordConfirm,
    suffix: IconButton(
      icon: Icon(
        obscurePasswordConfirm ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: () {
        obscurePasswordConfirm = !obscurePasswordConfirm;
        (context as Element).markNeedsBuild();
      },
    ),
    fillColor: theme.colorScheme.surface,
    textStyle: TextStyle(
      color: theme.colorScheme.onPrimaryContainer,
    ),
    hintText: "Ketik ulang password baru",
    // hintStyle: CustomTextStyles.bodySmallGray,
    textInputAction: TextInputAction.done,
    validator: validateConfirmPassword,
    onTapOutside: (value) {
      // inputPassword.unfocus();
    },
    onEditingComplete: () {},
  );
}
