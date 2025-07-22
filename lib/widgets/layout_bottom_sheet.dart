import 'package:flutter/material.dart';
import 'package:guardian_app/widgets/custom_elevated_button.dart';

class LayoutBottomSheet extends StatelessWidget {
  final double height; // Height of the white background
  final TextStyle titleTextStyle; // Text style for the title
  final String title; // Text for the title
  final String actionTitle; // Text for the action title
  final Widget? childComponent;
  final Function()?
      onActionClicked; // Callback function for action button click

  LayoutBottomSheet({
    Key? key,
    required this.height,
    required this.title,
    TextStyle? titleTextStyle,
    this.childComponent,
    this.actionTitle = 'Apply', // Default value for actionTitle
    this.onActionClicked,
  })  : titleTextStyle = titleTextStyle ??
            TextStyle(
              fontSize: 14.0, // Default font size
              fontWeight: FontWeight.bold,
              fontFamily: '', // Default font family
              color: Colors.black, // Default font color
            ),
        super(key: key);

  /* Event Handlers */
  Future<void> Function() onTapAction(BuildContext context) {
    return () async {
      // Call the callback when the action button is clicked
      if (onActionClicked != null) {
        await onActionClicked!();
      }
      Navigator.of(context).pop();
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity, // Set width to 100% of the screen
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: titleTextStyle,
            ),
          ),
          Expanded(
            child: Container(
              child: childComponent ??
                  SizedBox
                      .shrink(), // Use injected list content or an empty SizedBox
            ),
          ),
          Column(children: [
            Divider(),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
              child: CustomElevatedButton(
                text: actionTitle, // Use actionTitle here
                onPressed: onTapAction(context),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
