import 'package:flutter/material.dart';

final ThemeData AppTheme = _buildAppTheme();

ThemeData _buildAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    brightness: Brightness.light,
    primaryColor: Color(0xff8BA2A0),
    accentColor: Colors.orangeAccent,
    buttonColor: Colors.cyan[700],
    scaffoldBackgroundColor: Colors.white,
    cardColor: Color(0xffBCE4E1),
  );
}