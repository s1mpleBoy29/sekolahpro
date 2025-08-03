import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guardian_app/core/utils/string_ui.dart';
import 'package:guardian_app/widgets/modal_sekolah.dart';
import 'package:guardian_app/routes/app_routes.dart';

class StickyTopBar extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final Color lineColor;
  final Color activeColor;
  final String? titleFontFamily;
  final double titleFontSize;
  final String? subtitleFontFamily;
  final double? subtitleFontSize;
  final double? descriptionFontSize;
  final String? descriptionFontFamily;
  final bool? withBackButton;
  final Function(String, dynamic)? onFilterChanged;

  final List<String> filterDate;
  final String filterArea;

  final String? titleText;
  final String? subtitleText;

  final int? notificationCount;
  
  // PROPERTI BARU UNTUK FUNGSI ONTAP
  final VoidCallback? onTitleTap; 

  StickyTopBar({
    this.backgroundColor = Colors.blue,
    this.activeColor = Colors.blue,
    this.textColor = Colors.white,
    this.titleFontSize = 20.0,
    this.subtitleFontSize = 14.0,
    this.descriptionFontSize = 14.0,
    this.titleFontFamily = '',
    this.subtitleFontFamily = '',
    this.descriptionFontFamily = '',
    this.onFilterChanged,
    this.lineColor = Colors.grey,
    this.withBackButton = false,
    this.filterDate = const ['Today', 'This Week', 'This Month'],
    this.filterArea = '',
    this.notificationCount,
    this.titleText,
    this.subtitleText,
    // INISIALISASI PROPERTI BARU
    this.onTitleTap,
  });

  // Komentar fungsi lama openModalAreaScreen
  /*
  void openModalAreaScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext builder) {
        return ModalSekolahScreen(
          initialValue: filterArea,
          onApplied: (selectedValue) {
            if (onFilterChanged != null) {
              onFilterChanged!("area", selectedValue);
            }
          },
        );
      },
    );
  }
  */

  // Komentar fungsi lama onTapFilterArea
  /*
  void Function() onTapFilterArea(BuildContext context) {
    return () async {
      openModalAreaScreen(context);
    };
  }
  */

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: lineColor,
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (withBackButton ?? false)
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                      child: SvgPicture.asset(
                        'assets/images/arrow_back.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                InkWell(
                  // MENGGUNAKAN PROPERTI BARU onTitleTap
                  onTap: onTitleTap, 
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(withBackButton ?? false ? 8.0 : 0.0, 8.0, 16.0, 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              titleText ?? '${capitalizeWords(filterArea)}',
                              style: TextStyle(
                                color: textColor,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                fontFamily: titleFontFamily,
                              ),
                            ),
                            if (subtitleText != null && subtitleText!.isNotEmpty)
                              Text(
                                subtitleText!,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: subtitleFontSize,
                                  fontFamily: subtitleFontFamily,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 2),
                        Icon(Icons.arrow_drop_down, color: const Color(0xFF7D5C86)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.NotifikasiScreen);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    const Icon(
                      Icons.notifications_none,
                      size: 28,
                      color: Color(0xFF7D5C86),
                    ),
                    if (notificationCount != null && notificationCount! > 0)
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$notificationCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}