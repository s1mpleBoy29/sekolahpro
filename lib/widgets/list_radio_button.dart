import 'package:flutter/material.dart';
import 'package:guardian_app/core/app_export.dart';

class ListRadioButton extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final ValueChanged<String>? onItemSelected;
  final String? initialSelectedValue;
  final String keyValue;
  final String keyText;

  ListRadioButton({
    required this.data,
    this.onItemSelected,
    this.initialSelectedValue,
    this.keyValue = "value",
    this.keyText = "text",
  });

  @override
  _ListRadioButtonState createState() => _ListRadioButtonState();
}

class _ListRadioButtonState extends State<ListRadioButton> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialSelectedValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        final item = widget.data[index];
        final value = item[widget.keyValue].toString();
        return value == "header"
            ? Container(
                padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                color: appTheme.blueGray100, // Background color for the Row
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item[widget.keyText],
                        style: CustomTextStyles.bodySmallGray,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedValue = value;
                      });

                      if (widget.onItemSelected != null) {
                        widget.onItemSelected!(selectedValue);
                      }
                    },
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item[widget.keyText],
                            style: CustomTextStyles.bodySmallGray,
                          ),
                        ),
                        Radio(
                          value: value,
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value.toString();
                            });

                            if (widget.onItemSelected != null) {
                              widget.onItemSelected!(selectedValue);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      height: 1,
                    ),
                  ),
                ],
              );
      },
    );
  }
}
