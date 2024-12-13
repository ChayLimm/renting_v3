import 'dart:ui';

import 'package:flutter/material.dart';

Color red = const Color(0xFFEC5665);
Color yellow = const Color(0xFFF8A849);
Color green = const Color(0xFF4FAC80);


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
