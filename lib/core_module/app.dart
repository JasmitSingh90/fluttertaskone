import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_one/home_module/home.dart';
import 'package:flutter_task_one/home_module/home_bloc.dart';
import 'package:flutter_task_one/splash_module/splash.dart';
import '../theme/theme.dart' as theme;

import 'app_bloc.dart';
import 'app_provider.dart';

class FlutterTaskApp extends StatelessWidget {

  final AppBloc appBloc;

  FlutterTaskApp({
    @required this.appBloc,
  }) : assert(appBloc != null);

  @override
  Widget build(BuildContext context) {
    appBloc.setContext(context);

    return AppProvider(
      appBloc: appBloc,
      child: MaterialApp(
        title: 'Pics n Music',
        theme: theme.buildTheme(Theme.of(context).platform).copyWith(platform: TargetPlatform.iOS), // force iOS behaviour
        home: _buildRootPage(context),
        supportedLocales: [
          const Locale('en', 'US'),
        ],
      ),
    );
  }

  Widget _buildRootPage(BuildContext context) {
    final homeBloc = HomeBloc(appBloc: appBloc, context: context);

    return StreamBuilder<bool>(
      stream: appBloc.isInitialProcessing,
      initialData: true,
      builder: (context, snapshot) {
        if (snapshot.data) return SplashPage();
            return HomePage(
              title: "Pics n Music",
              homeBloc: homeBloc,
            );
        },
    );
  }
}