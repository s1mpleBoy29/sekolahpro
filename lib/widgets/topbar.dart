import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guardian_app/core/utils/string_ui.dart';
import 'package:guardian_app/widgets/modal_sekolah.dart';

class StickyTopBar extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final Color lineColor;
  final Color activeColor; // Changed from Color? to Color
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
  });

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

  void Function() onTapFilterArea(BuildContext context) {
    return () async {
      openModalAreaScreen(context);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor, // Set background color
        border: Border(
          bottom: BorderSide(
            color: lineColor, // Set the bottom border color
            width: 1.0, // Set the bottom border width
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (withBackButton ?? true)
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/arrow_back.svg',
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                InkWell(
                  onTap: onTapFilterArea(context),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${capitalizeWords(filterArea)}',
                          style: TextStyle(
                            color: textColor,
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: titleFontFamily,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.arrow_drop_down, color: Color(0xFF7D5C86)),
                      ],
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
