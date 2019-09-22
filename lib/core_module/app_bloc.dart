
import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_task_one/util/translations.dart';
import 'package:flutter_task_one/widgets/snackbar_overlay.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../main.dart';

/// Main Bloc for our application, it handles the following:
/// initialisation of app,
/// connectivity check, possible overall error and progress handling and more
class AppBloc {
  /// Section: Private variables
  BuildContext context;
  SnackbarOverlayHandler snackbarOverlayHandler;

  /// Section: Sinks and Strems
  
  Sink<BuildContext> get resetContext => _resetContextController.sink;
  final _resetContextController = StreamController<BuildContext>();

  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Connectivity _connectivity = Connectivity();

  Stream<bool> get isConnected => _isConnectedSubject.stream;
  final _isConnectedSubject = BehaviorSubject<bool>.seeded(true);

  Sink get showApiServiceError => _showApiServiceErrorController.sink;
  final _showApiServiceErrorController = StreamController();

  Stream<bool> get isInitialProcessing => _isInitialProcessingSubject.stream;
  final _isInitialProcessingSubject = BehaviorSubject<bool>.seeded(true);

  Sink<bool> get setInitialProcessing => _setIsInitialProcessingController.sink;
  final _setIsInitialProcessingController = StreamController<bool>();

  AppBloc() {
    // initialize sink listeners
    _resetContextController.stream.listen(_resetContext);
    _showApiServiceErrorController.stream.listen(_showApiServiceError);
    _isInitialProcessingSubject.add(true);

    _setIsInitialProcessingController.stream.listen((isInitialProcessing) => _isInitialProcessingSubject.add(isInitialProcessing));

    _init();
  }

  /// Dispose the streams
  void dispose() {
    _resetContextController.close();
    _connectivitySubscription.cancel();
    _isConnectedSubject.close();

    _showApiServiceErrorController.close();

    _isInitialProcessingSubject.close();
    _setIsInitialProcessingController.close();
  }

  /// Section: Public Methods
  
  /// Init the setup work
  void setContext(BuildContext context) {
    this.context = context;
  }

  /// Section: Private Methods

  void _resetContext(BuildContext context) {
    this.context = context;
    snackbarOverlayHandler = snackbarOverlayHandler ?? SnackbarOverlayHandler(context: context);
  }

  /// Init the setup work
  void _init() {
    _initConnectivity();
    _initRandomStuffs();
  }

  /// Init the generic method to check the application connectivity
  void _initConnectivity() async {
    _connectivity = _connectivity ?? Connectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      bool isConnected = result != ConnectivityResult.none;
      _isConnectedSubject.add(isConnected);

      if (!isConnected && snackbarOverlayHandler != null) {
        _displaySnackbarOverlay(Translations.of(context).text('error_message_offline'));
      }
    });
  }

  /// Note: Just to demonstrate the case wherein the Splash screen is displayed
  /// while performing some task, a delay of 2 secs has been added, before taking the splash screen off
  void _initRandomStuffs() async {
    await Future.delayed(Duration(seconds: 2));
    setInitialProcessing.add(false);
  }

  /// It will log the error and show it on snackbar
  ///
  /// Handle (by displaying) any error from [ApiService]
  ///
  /// Use this if the code didn't cater the error in anyway (e.g. by not showing a alert dialog at all)
  ///
  /// We need to show something to user (to let user know something has failed)
  void _showApiServiceError(dynamic error) {
    _handleApiServiceError(error, showAsSnackbar: true);
  }

  /// Handle (by displaying) any error from [ApiService]
  ///
  /// [error] can be [Tuple] or any object. if it is [Tuple] then the [Tuple.item2] will be
  /// the [StackTrace]
  void _handleApiServiceError(dynamic error, {bool showAsSnackbar = false}) {
    String message; 

    try {
      dynamic errorObject = error;
      StackTrace stackTrace = StackTrace.current;
      if (error is Tuple2) {
        errorObject = error.item1;
        stackTrace = error.item2;
      }

      // ignore io-error logging, since it will happen a lot
      if (errorObject is IOException || errorObject is TimeoutException) {
        message = 'Connection Error';
      } else {
        message = 'Unexpected Error';
      }

      // Note: Raise to report error
      onAppError(errorObject, stackTrace, isCrash: false);

      if (showAsSnackbar) {
        if (message != null) {
          _displaySnackbarOverlay(message, autoDismiss: true);
        }
      }
    } catch (e, st) {
      // Error handling the error :) 
    }
  }

  /// Generic method to display the snackbar overlay 
  void _displaySnackbarOverlay(String message, {bool autoDismiss = false}) {
    snackbarOverlayHandler.showSnackbarOverlay(message: message, autoDismiss: autoDismiss);
  }  
}


