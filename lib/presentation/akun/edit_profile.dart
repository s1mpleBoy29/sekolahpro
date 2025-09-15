import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guardian_app/core/app_export.dart';
import 'package:guardian_app/core/providers/auth_provider.dart';
import 'package:guardian_app/widgets/custom_elevated_button.dart';
import 'package:guardian_app/widgets/custom_text_form_field.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfilePageScreen createState() => EditProfilePageScreen();
}

class EditProfilePageScreen extends State<EditProfileScreen> {
  dynamic user;
  dynamic guardian;

  @override
  void initState() {
    super.initState();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = authProvider.user;
    guardian = authProvider.guardian;

    if (user != null || guardian != null) {
      setForm();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setForm() {
    setState(() {
      nikController.text = guardian['pin'] ?? '';
      nameController.text = user['full_name'] ?? '';
      // phoneController.text = user['phone'] ?? '';
      emailController.text = user['email'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: const Text(
          "Profil Saya",
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
        elevation: 0, // Memberikan sedikit bayangan
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nomor Induk Kependudukan (NIK)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            _inputNIK(context),
            const SizedBox(height: 16),
            Text(
              'Nama',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            _inputName(context),
            const SizedBox(height: 16),
            Text(
              'Nomor Handphone',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            _inputPhone(context),
            const SizedBox(height: 16),
            Text(
              'Email',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            _inputEmail(context),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            CustomElevatedButton(
              text: "SIMPAN",
              onPressed: () {},
              height: 48,
              buttonStyle: CustomButtonStyles.primaryButton,
              buttonTextStyle:
                  CustomTextStyles.labelLargeLatoOnPrimary.copyWith(
                fontSize: 12.fSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextEditingController nikController = TextEditingController();
Widget _inputNIK(BuildContext context) {
  return CustomTextFormField(
    controller: nikController,
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
    fillColor: theme.colorScheme.surface,
    textStyle: TextStyle(
      color: theme.colorScheme.onPrimaryContainer,
    ),
    hintText: "Masukin nik anda",
    // hintStyle: CustomTextStyles.bodySmallGray,
    textInputAction: TextInputAction.done,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'nik tidak boleh kosong';
      }
      return null;
    },
    onTapOutside: (value) {
      // inputPassword.unfocus();
    },
    onEditingComplete: () {
      // print('debug');
      // inputPassword.unfocus();
      // onTapMasuk(context);
    },
  );
}

TextEditingController nameController = TextEditingController();
Widget _inputName(BuildContext context) {
  return CustomTextFormField(
    controller: nameController,
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
    fillColor: theme.colorScheme.surface,
    textStyle: TextStyle(
      color: theme.colorScheme.onPrimaryContainer,
    ),
    hintText: "Masukin nama anda",
    textInputAction: TextInputAction.done,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'nama tidak boleh kosong';
      }
      return null;
    },
    onTapOutside: (value) {
      // inputPassword.unfocus();
    },
    onEditingComplete: () {
      // print('debug');
      // inputPassword.unfocus();
      // onTapMasuk(context);
    },
  );
}

TextEditingController phoneController = TextEditingController();
Widget _inputPhone(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(1),
    decoration: BoxDecoration(
      color: appTheme.gray300,
      borderRadius: BorderRadius.circular(5),
    ),
    child: IntlPhoneField(
      controller: phoneController,
      initialCountryCode: 'ID',
      disableLengthCheck: true,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: TextStyle(
        color: theme.colorScheme.onPrimaryContainer,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
      dropdownTextStyle: TextStyle(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 16,
      ),
      onChanged: (phone) {
        // +6281234567890
      },
    ),
  );
}

TextEditingController emailController = TextEditingController();
Widget _inputEmail(BuildContext context) {
  return CustomTextFormField(
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
    fillColor: theme.colorScheme.surface,
    textStyle: TextStyle(
      color: theme.colorScheme.onPrimaryContainer,
    ),
    controller: emailController,
    hintText: "Masukin email anda",
    textInputAction: TextInputAction.done,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'email tidak boleh kosong';
      }
      return null;
    },
    onTapOutside: (value) {
      // inputPassword.unfocus();
    },
    onEditingComplete: () {
      // print('debug');
      // inputPassword.unfocus();
      // onTapMasuk(context);
    },
  );
}
