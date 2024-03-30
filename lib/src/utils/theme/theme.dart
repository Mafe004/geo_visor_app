import 'package:flutter/material.dart';
import 'package:geo_visor_app/src/utils/theme/widget_themes/text_themes.dart';
import 'package:geo_visor_app/src/utils/theme/widget_themes/color_scheme.dart';

class GeoVisorTheme {
  GeoVisorTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    textTheme: GeoVisorTextThemes.lightTextTheme,
    colorScheme: lightScheme,

    primaryColor: Colors.red,
    secondaryHeaderColor: Colors.white,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    textTheme: GeoVisorTextThemes.darkTextTheme,
    colorScheme: darkScheme,

    primaryColor: Colors.red,
    secondaryHeaderColor: Colors.white,
  );
}

