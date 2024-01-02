import 'package:flutter/material.dart';
import 'package:gas_accounting/utill/color_resources.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Montserrat',
  primaryColor: ColorResources.LINE_BG,
  brightness: Brightness.dark,
  bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
  highlightColor: const Color(0xFF252525),
  hintColor: const Color(0xFFc7c7c7),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
