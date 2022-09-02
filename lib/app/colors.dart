// coverage:ignore-file
// ignore_for_file:public_member_api_docs

part of 'app.dart';

const kPrimaryColor = Colors.white;
const kTextAccentColor = Color(0xFF005793);
const kAccentColor = Color(0xFFfdbd2c);
const kPrimaryDarkColor = Color.fromARGB(255, 0, 42, 70);
const kSurfaceDarkColor = Color.fromARGB(255, 0, 30, 49);

Color primaryColor(Brightness brightness) =>
    brightness == Brightness.light ? kPrimaryColor : kPrimaryDarkColor;
Color get secondaryColor => kAccentColor;
Color textAccentColor(Brightness brightness) =>
    brightness == Brightness.light ? kTextAccentColor : kAccentColor;
Color surfaceColor(Brightness brightness) =>
    brightness == Brightness.light ? Colors.white : kSurfaceDarkColor;
