import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/colours.dart';

class GlobalStyle {
  Curve animationCurve = Curves.ease;
  Duration animationDuration = const Duration(milliseconds: 200);

  Map<String?, IconData> activityIcon = {
    null: Icons.monitor_heart_outlined,
    'activity': Icons.monitor_heart_outlined,
    'skydiving': Icons.paragliding,
    'scuba': Icons.scuba_diving,
    'running': Icons.run_circle_outlined,
    'driving': Icons.drive_eta_outlined,
    'flying': Icons.airplanemode_active,
  };

  ThemeData general(bool light) => ThemeData(
        useMaterial3: true,
        colorScheme: light ? generalLight : generalDark,
      );

  ThemeData skydiving(bool light) => ThemeData(
        useMaterial3: true,
        colorScheme: light ? skydivingLight : skydivingDark,
      );

  ThemeData scuba(bool light) => ThemeData(
        useMaterial3: true,
        // fontFamily: 'Raleway',
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: light ? scubaLight.tertiary : scubaDark.tertiary,
          enableFeedback: true,
        ),
        colorScheme: light ? scubaLight : scubaDark,
      );
}
