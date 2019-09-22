
import 'package:flutter/material.dart';

part 'colors.dart';

/// App Main Theme
ThemeData buildTheme(TargetPlatform platform) {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: kColorPrimary,
    accentColor: kColorAccent,
    brightness: Brightness.light,
    splashColor: platform == TargetPlatform.iOS ? Colors.transparent : null,
    // highlightColor: Colors.transparent,
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
    buttonColor: kColorPrimary,
    buttonTheme: _buildButtonTheme(base.buttonTheme)
  );
}

ButtonThemeData _buildButtonTheme(ButtonThemeData base) {
  return base.copyWith(
    padding: const EdgeInsets.all(15.0),
    textTheme: ButtonTextTheme.primary,
    buttonColor: kColorPrimary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.0),
    ),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    // H1
    display4: base.display4.copyWith(
      fontFamily: 'Whitney Book',
      color: kColorTextMain,
      fontWeight: FontWeight.normal,
      fontSize: 38.0,
      letterSpacing: 0.3,
    ),
    // H2
    display3: base.display3.copyWith(
      fontFamily: 'Whitney Book',
      color: kColorTextMain,
      fontWeight: FontWeight.normal,
      fontSize: 32.0,
    ),
    // H3
    display2: base.display2.copyWith(
      fontFamily: 'Whitney',
      color: kColorTextMain,
      fontWeight: FontWeight.w700,
      fontSize: 26.0,
    ),
    // H4
    display1: base.display1.copyWith(
      fontFamily: 'Whitney Book',
      color: kColorTextMain,
      fontWeight: FontWeight.normal,
      fontSize: 22.0,
    ),
    // H5
    headline: base.headline.copyWith(
      fontFamily: 'Whitney',
      color: kColorPrimary,
      fontWeight: FontWeight.w700,
      fontSize: 18.0,
    ),
    // Body 1
    body1: base.body1.copyWith(
      fontFamily: 'Whitney Book',
      color: kColorTextMain,
      fontWeight: FontWeight.normal,
      fontSize: 18.0,
    ),
    // Body 2
    body2: base.body2.copyWith(
      fontFamily: 'Whitney Book',
      color: kColorTextMain,
      fontWeight: FontWeight.normal,
      fontSize: 15.0,
    ),
    // Caption
    caption: base.caption.copyWith(
      fontFamily: 'Whitney Book',
      fontWeight: FontWeight.normal,
      fontSize: 14.0,
    ),
    // Button text
    button: base.button.copyWith(
      fontFamily: 'Whitney Book',
      color: kColorWhite,
      fontWeight: FontWeight.normal,
      fontSize: 18.0,
    ),
    // AppBar title
    title: base.title.copyWith(
      fontFamily: 'Whitney Book',
      fontWeight: FontWeight.normal,
      fontSize: 18.0,
    ),
    subhead: base.subhead.copyWith(
      fontFamily: 'Whitney',
      color: kColorTextMain,
      fontWeight: FontWeight.w700,
      fontSize: 15.0,
    ),
  );
}

TextStyle textStyleButtonText2() {
  return TextStyle(
    color: kColorPrimary,
    fontFamily: 'Whitney',
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
  );
}

TextStyle textStyleFine() {
  return TextStyle(
    fontFamily: 'Whitney Book',
    color: kColorTextFine,
    fontWeight: FontWeight.normal,
    fontSize: 10.0,
  );
}

TextStyle textStyleBodySmaller() {
  return TextStyle(
    fontFamily: 'Whitney Book',
    color: kColorTextMain,
    fontWeight: FontWeight.normal,
    fontSize: 14.0,
  );
}

/// Bottom Navigation Theme
ThemeData buildBottomNavigationTheme(ThemeData base) {
  return base.copyWith(
    primaryColor: kColorAccent,
  );
}

TextStyle textStyleBottomNavigationItem() {
  return TextStyle(
    fontFamily: 'Whitney Book',
    fontSize: 11.0,
  );
}

TextStyle textStyleButtonSmaller() {
  return TextStyle(
    fontFamily: 'Whitney Book',
    fontSize: 15.0,
  );
}

TextStyle textStyleUnreadCount() {
  return TextStyle(
    fontFamily: 'Whitney Book',
    fontSize: 9.0,
    color: kColorWhite,
  );
}