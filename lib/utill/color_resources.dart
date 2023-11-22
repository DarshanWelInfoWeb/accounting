import 'package:flutter/material.dart';
import 'package:gas_accounting/provider/theme_provider.dart';
import 'package:provider/provider.dart';


class ColorResources {

  static Color getWhite(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFFFFFFF) : Color(0xFFFFFFFF);
  }

  static Color getColombiaBlue(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF031A68) : Color(0xFF031A68);
  }

  static Color getYellow(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF031A68) : Color(0xFF031A68);
  }

  static Color getHomeBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFFFFFFF) : Color(0xFFFFFFFF);
  }

  static Color getChatIcon(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFebebeb) : Color(0xFFD4D4D4);
  }

  static const Color BLACK = Color(0xff000000);
  static const Color WHITE = Color(0xffFFFFFF);
  static const Color GREY = Color(0xff696969);
  static const Color LIGHT_GREY = Color(0xffC4C4C4);
  static const Color SERVICES_SELECT_BG = Color(0xffC5C5CC);
  static const Color RED = Color(0xFFFC3A32);
  static const Color LIGHT_GREEN = Color(0xFF7CCACA);
  static const Color gradient_top = Color(0xFF031A68);
  static const Color gradient_bottom = Color(0xFF031A68);
  static const Color LINE_BG = Color(0xFF162466);
  static const Color TEXT_COLOR = Color(0xffD9D9D9);
  static const Color GREEN = Colors.green;
  static const Color transparant=Color(0xff00ECECEC);
  static const Color List_BG=Color(0xff4662A5);
  static const Color TEXT_COLOR_BLUE=Color(0xff334E93);
  static const Color COLORPRIMERY=Color(0xFF031A68);
  static const Color COLORPRIMERY1 = Color(0xFF031A68);
  static const Color SUBSCRIPTION_TITLE=Color(0xff858888);
  static const Color RED_1=Color(0xffFE0303);
  static const Color RED_2=Color(0xffFE0303);
  static const Color HINT_TEXT_COLOR = Color(0xff9E9E9E);
  static const Color BACKGROUND_COLOR = Color(0xfff8f8ff);
  static const Map<int, Color> colorMap = {
    50: Color(0x10192D6B),
    100: Color(0x20192D6B),
    200: Color(0x30192D6B),
    300: Color(0x40192D6B),
    400: Color(0x50192D6B),
    500: Color(0x60192D6B),
    600: Color(0x70192D6B),
    700: Color(0x80192D6B),
    800: Color(0x90192D6B),
    900: Color(0xff192D6B),
  };

  static const MaterialColor PRIMARY_MATERIAL = MaterialColor(0xFF192D6B, colorMap);
}
