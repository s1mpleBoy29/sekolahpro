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
  String? originalNik;
  String? originalName;
  String? originalEmail;
  String? originalPhone;
  final ValueNotifier<bool> isChanged = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = authProvider.user;
    guardian = authProvider.guardian;

    if (user != null || guardian != null) {
      setForm();
    }

    nikController.addListener(checkChanged);
    nameController.addListener(checkChanged);
    phoneController.addListener(checkChanged);
    emailController.addListener(checkChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    isChanged.dispose();
    super.dispose();
  }

  void setForm() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        originalNik = guardian['pin'] ?? '';
        originalName = user['full_name'] ?? '';
        originalEmail = user['email'] ?? '';

        String apiPhone = guardian['whatsapp'] ?? '';
        String cleaned = apiPhone.replaceAll(RegExp(r'[^0-9+]'), '');
        String number = '';

        if (cleaned.startsWith('+62')) {
          number = cleaned.replaceFirst('+62', ''); // 89654562911
        } else {
          // fallback: langsung ambil
          number = cleaned;
        }
        phoneController.text = number;
        originalPhone = number;

        nikController.text = originalNik!;
        nameController.text = originalName!;
        emailController.text = originalEmail!;
        phoneController.text = originalPhone!;
      }),
    );
  }

  void checkChanged() {
    String nik = nikController.text.trim();
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();

    final hasChanged = nik != (originalNik ?? '').trim() ||
        name != (originalName ?? '').trim() ||
        phone != (originalPhone ?? '').trim() ||
        email != (originalEmail ?? '').trim();

    if (hasChanged != isChanged.value) {
      isChanged.value = hasChanged;
    }
  }

  void unfocusAll() {
    nikFocus.unfocus();
    nameFocus.unfocus();
    phoneFocus.unfocus();
    emailFocus.unfocus();
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
              ValueListenableBuilder<bool>(
                valueListenable: isChanged,
                builder: (context, changed, _) {
                  return CustomElevatedButton(
                    text: "SIMPAN",
                    onPressed: changed
                        ? () {
                            // TODO: save action
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
              // CustomElevatedButton(
              //   text: "SIMPAN",
              //   onPressed: isChanged ? () {} : null,
              //   height: 48,
              //   buttonStyle: isChanged
              //       ? CustomButtonStyles.primaryButton
              //       : CustomButtonStyles.disabledButton,
              //   buttonTextStyle:
              //       CustomTextStyles.labelLargeLatoOnPrimary.copyWith(
              //     fontSize: 12.fSize,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

TextEditingController nikController = TextEditingController();
FocusNode nikFocus = FocusNode();
Widget _inputNIK(BuildContext context) {
  return CustomTextFormField(
    autofocus: false,
    controller: nikController,
    focusNode: nikFocus,
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
FocusNode nameFocus = FocusNode();
Widget _inputName(BuildContext context) {
  return CustomTextFormField(
    autofocus: false,
    controller: nameController,
    focusNode: nameFocus,
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
FocusNode phoneFocus = FocusNode();
Widget _inputPhone(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(1),
    decoration: BoxDecoration(
      color: appTheme.gray300,
      borderRadius: BorderRadius.circular(5),
    ),
    child: IntlPhoneField(
      autofocus: false,
      controller: phoneController,
      focusNode: phoneFocus,
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
FocusNode emailFocus = FocusNode();
Widget _inputEmail(BuildContext context) {
  return CustomTextFormField(
    autofocus: false,
    focusNode: emailFocus,
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
