import 'package:flutter/material.dart';
import 'package:geo_visor_app/src/features/menu_geovisor/screens/index_geovisor/index_screen.dart';
import 'package:geo_visor_app/src/routing/routes.dart';
import 'package:geo_visor_app/src/utils/theme/theme.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: GeoVisorTheme.lightTheme,
      darkTheme: GeoVisorTheme.darkTheme,
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      getPages: routes,
      home: const IndexScreen(),
    );
  }
}
