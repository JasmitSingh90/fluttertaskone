import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core_module/app.dart';
import 'core_module/app_bloc.dart';

void main() async {
  // Set orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final appBloc = AppBloc();

  runZoned<Future<Null>>(() async {
    runApp(FlutterTaskApp(
      appBloc: appBloc,
    ));
  }, onError: (error, stackTrace) async {
    // Call the below function to raise the error
    onAppError(error, stackTrace, isCrash: true);
  });
}

/// Call this to report crash/error
Future onAppError(error, stackTrace, {bool isCrash = true}) async {
  // Add code to raise this to either Fabric / any other service
}