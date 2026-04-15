import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF000a2e);

class AppTheme {
  ThemeData getTheme() => ThemeData(useMaterial3: true, colorSchemeSeed: primaryColor);
}
