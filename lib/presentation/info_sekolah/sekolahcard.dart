import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class SchoolCard extends StatelessWidget {
  final String schoolName;
  final String phone;
  final String email;
  final String address;
  final String? city;
  final String? province;
  final String? map;
  final VoidCallback? onSendEmail;
  final VoidCallback? onPhone;
  final VoidCallback? onMap;

  const SchoolCard({
    super.key,
    required this.schoolName,
    required this.phone,
    required this.email,
    required this.address,
    this.city,
    this.province,
    this.map,
    this.onSendEmail,
    this.onPhone,
    this.onMap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Gunakan nilai numerik
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), // Gunakan nilai numerik
        border: Border.all(
          color: appTheme.gray300,
          width: 1, // Gunakan nilai numerik
        ),
        color: theme.colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama Sekolah
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
                20, 20, 20, 16), // Gunakan nilai numerik
            child: Text(
              schoolName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),

          // Garis pembatas setelah nama sekolah
          Divider(
            color: appTheme.gray300,
            height: 1, // Gunakan nilai numerik
            thickness: 1, // Gunakan nilai numerik
          ),

          // Telepon dan Email dengan pembatas vertikal
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 16), // Tambahkan padding vertikal
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Telepon
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.phone,
                          size: 14, // Ukuran ikon yang lebih kecil
                          color: appTheme.gray500,
                        ),
                        const SizedBox(width: 8), // Jarak yang lebih kecil
                        Expanded(
                          child: Text(
                            phone != '' ? phone : '-',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: phone != ''
                                  ? theme.colorScheme.onSurface
                                  : appTheme.gray500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (email != '') ...[
                    Container(
                      width: 1, // Gunakan nilai numerik
                      height: double.infinity,
                      color: appTheme.gray300,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16), // Gunakan nilai numerik
                    ),

                    // Email
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.email,
                            size: 14, // Ukuran ikon yang lebih kecil
                            color: appTheme.gray500,
                          ),
                          const SizedBox(width: 8), // Jarak yang lebih kecil
                          Expanded(
                            child: Text(
                              email,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: email != ''
                                    ? theme.colorScheme.onSurface
                                    : appTheme.gray500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Garis pembatas setelah telepon/email
          Divider(
            color: appTheme.gray200,
            height: 1, // Gunakan nilai numerik
            thickness: 1, // Gunakan nilai numerik
          ),

          // Alamat
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
                20, 16, 20, 20), // Gunakan nilai numerik
            child: Row(
              children: [
                Text(
                  address != '' ? address : '-',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: address != ''
                        ? theme.colorScheme.onSurface
                        : appTheme.gray500,
                  ),
                ),
                if (city != null)
                  Text(
                    ', ${city!}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface),
                  ),
                if (province != null)
                  Text(
                    ', ${province!}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface),
                  ),
              ],
            ),
          ),
          Divider(
            color: appTheme.gray300,
            height: 1, // Gunakan nilai numerik
            thickness: 1, // Gunakan nilai numerik
          ),

          SizedBox(
            height: 48,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onSendEmail,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: appTheme.gray300,
                            width: 1, // Gunakan nilai numerik
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Kirim Email',
                          style: TextStyle(
                            color: email != ''
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
                            fontSize: 14, // Gunakan nilai numerik
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: onPhone,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: appTheme.gray300,
                            width: 1, // Gunakan nilai numerik
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Telepon',
                          style: TextStyle(
                            color: phone != ''
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
                            fontSize: 14, // Gunakan nilai numerik
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: onMap,
                    child: Center(
                      child: Text(
                        'Lihat Peta',
                        style: TextStyle(
                          color: map != ''
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline,
                          fontSize: 14, // Gunakan nilai numerik
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
