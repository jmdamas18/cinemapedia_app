import 'package:flutter/material.dart';

const Color _primaryColor = Color(0xFF0053cc);

class AppTheme {
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _primaryColor, primary: _primaryColor, brightness: Brightness.dark),
  );
}
