import 'package:flutter/material.dart';

Map<int, Color> lightColor = {
  50: const Color.fromRGBO(239, 241, 243, 0.1),
  100: const Color.fromRGBO(239, 241, 243, 0.2),
  200: const Color.fromRGBO(239, 241, 243, 0.3),
  300: const Color.fromRGBO(239, 241, 243, 0.4),
  400: const Color.fromRGBO(239, 241, 243, 0.5),
  500: const Color.fromRGBO(239, 241, 243, 0.6),
  600: const Color.fromRGBO(239, 241, 243, 0.7),
  700: const Color.fromRGBO(239, 241, 243, 0.8),
  800: const Color.fromRGBO(239, 241, 243, 0.9),
  900: const Color.fromRGBO(239, 241, 243, 1.0),
};

Map<int, Color> darkColor = {
  50: const Color.fromRGBO(0, 39, 43, 0.1),
  100: const Color.fromRGBO(0, 39, 43, 0.2),
  200: const Color.fromRGBO(0, 39, 43, 0.3),
  300: const Color.fromRGBO(0, 39, 43, 0.4),
  400: const Color.fromRGBO(0, 39, 43, 0.5),
  500: const Color.fromRGBO(0, 39, 43, 0.6),
  600: const Color.fromRGBO(0, 39, 43, 0.7),
  700: const Color.fromRGBO(0, 39, 43, 0.8),
  800: const Color.fromRGBO(0, 39, 43, 0.9),
  900: const Color.fromRGBO(0, 39, 43, 1.0),
};

MaterialColor lightCustom = MaterialColor(0xFFEFF1F3, lightColor);
MaterialColor darkCustom = MaterialColor(0xFF00272B, darkColor);

var themeLight = ThemeData(
  primaryColor: darkCustom,
  primaryColorDark: lightCustom,
  primarySwatch: lightCustom,
  bottomAppBarColor: lightCustom,
  scaffoldBackgroundColor: lightCustom,
  dividerColor: darkCustom.shade300,
  hintColor: darkCustom.shade300,
  iconTheme: IconThemeData(
    color: darkCustom,
  ),
  listTileTheme: ListTileThemeData(
    iconColor: darkCustom,
  ),
);
var themeDark = ThemeData(
  primaryColor: lightCustom,
  primaryColorDark: darkCustom,
  primarySwatch: darkCustom,
  bottomAppBarColor: darkCustom,
  scaffoldBackgroundColor: darkCustom,
  dividerColor: lightCustom.shade300,
  hintColor: lightCustom.shade300,
  iconTheme: IconThemeData(
    color: lightCustom,
  ),
  listTileTheme: ListTileThemeData(
    iconColor: lightCustom,
  ),
);
