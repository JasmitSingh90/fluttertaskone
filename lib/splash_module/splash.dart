import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_one/widgets/progress_indicator_default.dart';
import '../theme/theme.dart' as theme;

class SplashPage extends StatelessWidget {

  SplashPage();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    // Do the initial app setup, if required

    return Scaffold(
      backgroundColor: theme.kColorSecondary,
      body: SizedBox.expand(
        child: Center(child: ProgressIndicatorDefault()),
      ),
    );
  }
}