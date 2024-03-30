import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GeoVisorTextThemes {
  static TextTheme  lightTextTheme = TextTheme(
    displayLarge: const TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.bold
    ),

    titleLarge: GoogleFonts.ubuntu(
      fontSize: 35,
    ),

  );
  static TextTheme darkTextTheme = TextTheme(
    displayLarge: const TextStyle(
      fontSize: 44,
      fontWeight: FontWeight.bold,
    ),

    titleLarge: GoogleFonts.ubuntu(
      fontSize: 35,
    ),
  );
}