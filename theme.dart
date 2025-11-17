import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  scaffoldBackgroundColor: const Color(0xFF0B0F1A),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0B0F1A),
    elevation: 0,
  ),
  cardColor: const Color(0xFF111623),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);
