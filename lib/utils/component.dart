import 'package:auto_size_text/auto_size_text.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

Color red = const Color(0xFFEC5665);
Color yellow = const Color(0xFFF8A849);
Color green = const Color(0xFF4FAC80);
Color grey = const Color(0xFF757575);
Color blue = const Color(0xFF4A90E2);

BoxShadow shadow() => BoxShadow(
      color: Colors.black.withOpacity(0.2),
      spreadRadius: 1,
      blurRadius: 10,
      offset: const Offset(3, 3),
    );

Text label(String label, {Color color = Colors.black}) => Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );

Container divider([double? margin, double? indent]) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: margin != null ? margin : 0),
    child: Divider(
      thickness: 1,
      color: grey,
      endIndent: indent,
      indent: indent,
    ),
  );
}

Future<bool> showAgreementDialog(
    BuildContext context, String title, String content) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false, // User must choose an option
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(content),
            title: Text(title),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // No
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Yes
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      ) ??
      false;
}

Future<DateTime?> selectDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(), // Default to today
    firstDate:
        DateTime.now().subtract(Duration(days: 30)), // 30 days in the past
    lastDate: DateTime.now().add(Duration(days: 30)),
  );

  return pickedDate;
}

Widget customeButton(
        {required BuildContext context,
        required VoidCallback trigger,
        required String label,
        Color? color}) =>
    GestureDetector(
      onTap: () {
        print("click!");
        trigger;
        print("after clik!");
      },
      child: Container(
          height: 44,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: color ?? blue, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            label,
            style: TextStyle(color: Colors.white),
          ))),
    );

void showCustomSnackBar(
    BuildContext context, String message, Color backgroundColor,
    {Duration duration = const Duration(seconds: 3)}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      duration: duration,
    ),
  );
}

TextFormField buildTextFormField({
  String? label,
  String? initialValue,
  String suffix = " ",
  required Function(String) onChanged,
  required String? Function(String?) validator,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextFormField(
    initialValue: initialValue,
    onChanged: onChanged,
    validator: validator,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      
      suffix: Text(suffix),
      labelText: label, 
      border:  OutlineInputBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      focusedBorder:  OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(10)
      ),
      floatingLabelStyle:TextStyle(color: blue)
    ),
  );
}

Widget buildDetailRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      AutoSizeText(label),
      AutoSizeText(value),
    ],
  );
}
