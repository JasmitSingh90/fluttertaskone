
import 'package:flutter/material.dart';

part 'colors.dart';

/// App Main Theme
ThemeData buildTheme(TargetPlatform platform) {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: kColorPrimary,
    accentColor: kColorAccent,
    brightness: Brightness.light,
    splashColor: null,
  );
}