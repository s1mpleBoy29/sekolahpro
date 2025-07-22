/* Scafold Import */
import 'package:flutter/material.dart';
import 'package:guardian_app/theme/app_decoration.dart';
import 'package:guardian_app/theme/custom_text_style.dart';
import 'package:guardian_app/theme/theme_helper.dart';
import 'package:guardian_app/widgets/custom_image_view.dart';
import 'package:guardian_app/widgets/modal_sekolah.dart';

class SlotSekolah extends StatelessWidget {
  final String filterData;
  final String filterOutlet;
  final Function(String, dynamic)? onFilterChanged;

  const SlotSekolah({
    Key? key,
    required this.onFilterChanged,
    required this.filterOutlet,
    this.filterData = '',
  }) : super(key: key);

  // Event handler
  void _onTapActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext builder) {
        return ModalSekolahScreen(
          initialValue: filterOutlet,
          onApplied: (selectedValue) async {
            if (onFilterChanged != null) {
              onFilterChanged!("outlet", selectedValue);
            }
          },
        );
      },
    );
  }

  // functions
  // String _translateTitle(String value) {
  //   return findValueByKey(AppState().filterOptionsWarehouseOutlet, "code",
  //       "name", value, "All Outlet");
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 5.0), // Adjusted padding
      decoration: AppDecoration.fillOnPrimary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _onTapActionMenu(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // CustomImageView(
                        //   svgPath: ImageConstant.imgHome,
                        //   height: 10,
                        //   width: 10,
                        //   margin: EdgeInsets.only(bottom: 1.v),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(top: 2, left: 1),
                          child: Text(
                            "Outlet",
                            style: CustomTextStyles.bodySmallGray,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          filterOutlet,
                          style: theme.textTheme.bodySmall,
                        ),
                        Icon(Icons.arrow_drop_down, color: Color(0xFF7D5C86)),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
