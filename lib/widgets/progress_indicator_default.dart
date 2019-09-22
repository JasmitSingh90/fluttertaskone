import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/theme.dart' as theme;

class ProgressIndicatorDefault extends StatelessWidget {
  final bool useLightStroke;

  ProgressIndicatorDefault({
    this.useLightStroke = false,
  });

  @override
  Widget build(BuildContext context) {
    return _buildMaterialProgressIndicator(context);
  }

  Widget _buildMaterialProgressIndicator(BuildContext context) {
    ThemeData base = Theme.of(context);
    return Theme(
      data: base.copyWith(accentColor: useLightStroke ? theme.kColorWhite : base.primaryColor),
      child: CircularProgressIndicator(),
    );
  }
}