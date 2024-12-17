
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

Text label(String label,{Color color = Colors.black}) => Text(
      label,
      style:  TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );

Future<bool> showAgreementDialog(BuildContext context,String title,String content) async {
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
            child:const Text('No'),
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
  ) ?? false; 
}
void showCustomSnackBar(BuildContext context, String message, Color backgroundColor, {Duration duration = const Duration(seconds: 3)}) {
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
CurvedNavigationBar navBar(GlobalKey<CurvedNavigationBarState> key,Function(int) trigger)=>
CurvedNavigationBar(
          key: key,
          items: <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.summarize, size: 30),
            Icon(Icons.price_check, size: 30),
          ],
          onTap: (index) {
           trigger(index);
          },
);
