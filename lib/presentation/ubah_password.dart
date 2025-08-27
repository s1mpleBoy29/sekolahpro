import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class UbahPasswordScreen extends StatefulWidget {
  const UbahPasswordScreen({Key? key}) : super(key: key);

  @override
  UbahPasswordPageScreen createState() => UbahPasswordPageScreen();
}

class UbahPasswordPageScreen extends State<UbahPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordLamaController = TextEditingController();
  final _passwordBaruController = TextEditingController();
  final _ketikUlangPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _passwordLamaController.dispose();
    _passwordBaruController.dispose();
    _ketikUlangPasswordController.dispose();
    super.dispose();
  }

  Future<void> _konfirmasiUbahPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulasi proses ubah password
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Password berhasil diubah',
              style: CustomTextStyles.textSuccess,
            ),
            backgroundColor: appTheme.green600,
          ),
        );

        Navigator.pop(context);
      }
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    
    // Validasi kombinasi angka, huruf, dan karakter khusus
    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasLowercase = value.contains(RegExp(r'[a-z]'));
    final hasDigits = value.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
    
    if (!hasUppercase || !hasLowercase || !hasDigits || !hasSpecialCharacters) {
      return 'Password harus mengandung huruf besar, kecil, angka, dan karakter khusus';
    }
    
    return null;
  }

  String? _validateKonfirmasiPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordBaruController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: true,
      style: CustomTextStyles.titleMediumPrimaryContainer.copyWith(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: CustomTextStyles.titleMediumPrimaryContainer.copyWith(
          color: appTheme.gray500,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: appTheme.blueGray100,
            width: 1.h,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: appTheme.blueGray100,
            width: 1.h,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.h,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: theme.colorScheme.onError,
            width: 1.h,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: theme.colorScheme.onError,
            width: 1.h,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.h,
          vertical: 16.v,
        ),
        errorStyle: CustomTextStyles.bodySmallOnError,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.colorScheme.onPrimaryContainer,
            size: 15.h,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Ubah Password',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontSize: 18.fSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kata sandi Anda harus memiliki panjang minimal 6 karakter dan harus menyertakan kombinasi angka, huruf, serta karakter khusus seperti (!@#\$%)',
                  style: CustomTextStyles.bodySmallGray600_1.copyWith(
                    fontSize: 14.fSize,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 30.v),

                _buildPasswordField(
                  controller: _passwordLamaController,
                  hintText: 'Password lama',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password lama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.v),

                _buildPasswordField(
                  controller: _passwordBaruController,
                  hintText: 'Password baru',
                  validator: _validatePassword,
                ),
                SizedBox(height: 16.v),

                _buildPasswordField(
                  controller: _ketikUlangPasswordController,
                  hintText: 'Ketik ulang password baru',
                  validator: _validateKonfirmasiPassword,
                ),
                SizedBox(height: 30.v),

                SizedBox(
                  width: double.infinity,
                  height: 50.v,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _konfirmasiUbahPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      disabledBackgroundColor: appTheme.gray300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20.h,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.onPrimary,
                              strokeWidth: 2.h,
                            ),
                          )
                        : Text(
                            'Konfirmasi',
                            style: CustomTextStyles.labelLargeLatoOnPrimary.copyWith(
                              fontSize: 16.fSize,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}