import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class SekolahCard extends StatelessWidget {
  final String namaSekolah;
  final String telepon;
  final String email;
  final String alamat;
  final VoidCallback? onKirimEmail;
  final VoidCallback? onTelepon;
  final VoidCallback? onLihatPeta;

  const SekolahCard({
    Key? key,
    required this.namaSekolah,
    required this.telepon,
    required this.email,
    required this.alamat,
    this.onKirimEmail,
    this.onTelepon,
    this.onLihatPeta,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16), // Gunakan nilai numerik
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Gunakan nilai numerik
        border: Border.all(
          color: appTheme.gray600,
          width: 1, // Gunakan nilai numerik
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama Sekolah
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 16), // Gunakan nilai numerik
            child: Text(
              namaSekolah,
              style: CustomTextStyles.titleMediumPrimaryContainer.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18, // Gunakan nilai numerik
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Tambahkan padding vertikal
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
                          size: 20, // Ukuran ikon yang lebih kecil
                          color: appTheme.gray600,
                        ),
                        SizedBox(width: 8), // Jarak yang lebih kecil
                        Expanded(
                          child: Text(
                            telepon,
                            style: CustomTextStyles.bodySmallGray600_1.copyWith(
                              fontSize: 14, // Gunakan nilai numerik
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Garis pembatas vertikal
                  if (email != '-') ...[
                    Container(
                      width: 1, // Gunakan nilai numerik
                      height: double.infinity,
                      color: appTheme.gray300,
                      margin: EdgeInsets.symmetric(horizontal: 16), // Gunakan nilai numerik
                    ),
                    
                    // Email
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.email,
                            size: 20, // Ukuran ikon yang lebih kecil
                            color: appTheme.gray600,
                          ),
                          SizedBox(width: 8), // Jarak yang lebih kecil
                          Expanded(
                            child: Text(
                              email,
                              style: CustomTextStyles.bodySmallGray600_1.copyWith(
                                fontSize: 14, // Gunakan nilai numerik
                              ),
                              overflow: TextOverflow.ellipsis,
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
            color: appTheme.gray300,
            height: 1, // Gunakan nilai numerik
            thickness: 1, // Gunakan nilai numerik
          ),

          // Alamat
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 16, 20, 20), // Gunakan nilai numerik
            child: Text(
              alamat,
              style: CustomTextStyles.bodySmallGray600_1.copyWith(
                fontSize: 14, // Gunakan nilai numerik
                height: 1.5,
              ),
            ),
          ),

          // Garis pembatas sebelum action buttons
          Divider(
            color: appTheme.gray300,
            height: 1, // Gunakan nilai numerik
            thickness: 1, // Gunakan nilai numerik
          ),

          // Action Buttons berdempetan
          Container(
            height: 48, // Gunakan nilai numerik
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onKirimEmail,
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
                            color: theme.colorScheme.primary,
                            fontSize: 14, // Gunakan nilai numerik
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: onTelepon,
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
                            color: theme.colorScheme.primary,
                            fontSize: 14, // Gunakan nilai numerik
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: onLihatPeta,
                    child: Center(
                      child: Text(
                        'Lihat Peta',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 14, // Gunakan nilai numerik
                          fontWeight: FontWeight.w500,
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
