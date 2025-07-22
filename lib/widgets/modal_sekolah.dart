import 'package:flutter/material.dart';
import 'package:guardian_app/widgets/layout_bottom_sheet.dart';
import 'package:guardian_app/widgets/list_radio_button.dart';

class ModalSekolahScreen extends StatefulWidget {
  final void Function(String) onApplied;
  final String? initialValue; // Added initial value property

  ModalSekolahScreen({Key? key, required this.onApplied, this.initialValue})
      : super(key: key);

  @override
  _ModalSekolahScreenState createState() => _ModalSekolahScreenState();
}

class _ModalSekolahScreenState extends State<ModalSekolahScreen> {
  // List of filters
  final List<Map<String, dynamic>> dataList = [
    {"text": "All", "value": "all"},
    {"text": "SMPN 13 Malang", "value": "smpn_13_malang"},
    {"text": "East Java", "value": "east_java"},
    {"text": "Malang", "value": "malang"},
  ];

  // Variable to hold the selected value
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    // Set the initial selected value
    selectedValue = widget.initialValue ?? "malang";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBottomSheet(
        height: MediaQuery.of(context).size.height * 0.90,
        title: "Select Area",
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        childComponent: ListRadioButton(
          data: dataList,
          onItemSelected: (value) {
            // Update the selected value when an item is selected
            setState(() {
              selectedValue = value;
            });
          },
          initialSelectedValue: selectedValue,
        ),
        onActionClicked: () {
          // Pass the selected value back to the calling code
          widget.onApplied(selectedValue);
        },
      ),
    );
  }
}
