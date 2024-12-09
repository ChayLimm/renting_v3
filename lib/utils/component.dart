import 'dart:ui';

import 'package:flutter/material.dart';

Color red = const Color(0xFFFF0000);
Color yellow = const Color(0xFFF8A849);
Color green = const Color(0xFF4FAC80);

BoxShadow shadow() => BoxShadow(
      color: Colors.black.withOpacity(0.2),
      spreadRadius: 1,
      blurRadius: 10,
      offset: const Offset(3, 3),
    );

Text label(String label) => Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
