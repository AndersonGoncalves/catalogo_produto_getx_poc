import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  static const Color _canvasColor = Color.fromRGBO(240, 240, 240, 1);
  static const Color _primaryColor = Color.fromRGBO(0, 64, 102, 1);
  static const Color _secundaryColor = Colors.pink; //fromRGBO(255, 159, 0, 1);

  static final ThemeData _tema = ThemeData();

  ThemeConfig._();

  static ThemeData get theme => ThemeData(
    canvasColor: _canvasColor,
    scaffoldBackgroundColor: _canvasColor,

    textTheme: GoogleFonts.mandaliTextTheme(),

    colorScheme: _tema.colorScheme.copyWith(
      primary: _primaryColor,
      secondary: _secundaryColor,
    ),

    iconTheme: const IconThemeData(size: 24),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _secundaryColor,
      foregroundColor: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(fontSize: 20, color: Colors.white),
      backgroundColor: _primaryColor,
      surfaceTintColor: _primaryColor,
      foregroundColor: Colors.white,
    ),
  );
}
