
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_task_one/core_module/app_bloc.dart';
import 'package:flutter_task_one/core_module/app_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class HomeBloc {
  /// Section: Public variables
  final AppBloc appBloc;
  BuildContext context;
  
  /// Section: Private variables
  bool _connectedToService = false;

  /// Section: Sinks and Strems
  Sink get loadData => _loadDataController.sink;
  final _loadDataController = StreamController();

  Stream<String> get imageData => _imageDataSubject.stream;
  final _imageDataSubject = BehaviorSubject<String>();

  HomeBloc({
    @required this.appBloc,
    @required this.context,
  }) : assert(appBloc != null),
       assert(context != null) {
    // initialize sink listeners
    _loadDataController.stream.listen(_getImageArrayBytes);
  }

  /// Dispose the streams
  void dispose() {
    _loadDataController.close();
    _imageDataSubject.close();
  }

  /// Section: Public Methods
  
  /// Init the setup work
  void setContext(BuildContext context) {
    this.context = context;
    // first reset app bloc context
    appBloc.resetContext.add(context);

    loadData.add(null); // Load the data
  }

  /// Section: Private Methods

  /// Method to get the Image data in byte arrays
  void _getImageArrayBytes(void event) async {
    String imageByteArrayResult;

    final appBloc = AppProvider.of(context); // Get the application provider   

    try {
      MethodChannel platform = MethodChannel('com.example.flutter_task_one/service');

      // Connect to the service
      if (!_connectedToService) {
        await platform.invokeMethod<bool>('connect');
        _connectedToService = true;
      }
    
      // All good, now raise a call to get data
      imageByteArrayResult = await platform.invokeMethod<String>('getImageData');
      print(imageByteArrayResult);
      
    } catch (e, st) {
      if(!(e is PlatformException)) {
        appBloc.showApiServiceError.add(Tuple2(e, st));
      }

      print('Failed invoking platform method');
    }

    _imageDataSubject.add(imageByteArrayResult);
  }
}


