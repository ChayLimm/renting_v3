import 'package:flutter/material.dart';

class DeviceType {
  static bool isMobile(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return width < 600; 
  }

  static bool isTablet(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024; 
  }

  static bool isDesktop(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return width >= 1024; 
  }
}
