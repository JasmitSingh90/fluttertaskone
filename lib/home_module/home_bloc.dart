
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_task_one/core_module/app_bloc.dart';
import 'package:flutter_task_one/core_module/app_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class HomeBloc {

  /// 
  /// Section: Public variables
  /// 
  final AppBloc appBloc;
  BuildContext context;
  
  /// 
  /// Section: Private variables
  /// 
  bool _connectedToService = false;
  static const MethodChannel _platform = MethodChannel('com.example.flutter_task_one/service');

  /// 
  /// Section: Sinks and Streams
  /// 
  Sink<bool> get setIsConnectedToService => _setIsConnectedToService.sink;
  final _setIsConnectedToService = BehaviorSubject<bool>.seeded(false);

  Sink get loadData => _loadDataController.sink;
  final _loadDataController = StreamController();

  Stream<List<Uint8List>> get imagesData => _imagesDataSubject.stream;
  final _imagesDataSubject = BehaviorSubject<List<Uint8List>>();

  Sink get toggleMediaPlayer => _toggleMediaPlayerController.sink;
  final _toggleMediaPlayerController = StreamController();

  HomeBloc({
    @required this.appBloc,
    @required this.context,
  }) : assert(appBloc != null),
       assert(context != null) {
    // initialize sink listeners
    _setIsConnectedToService.stream.listen((isConnectedToService) => _connectedToService = isConnectedToService);
    _loadDataController.stream.listen(_getImageArrayBytes);
    _toggleMediaPlayerController.stream.listen(_toggleMediaPlayer);
  }

  /// Dispose the streams
  void dispose() {
    _setIsConnectedToService.close();
    _loadDataController.close();
    _imagesDataSubject.close();
    _toggleMediaPlayerController.close();
  }

  /// 
  /// Section: Public Methods
  /// 
  
  /// Init the setup work
  void setContext(BuildContext context) {
    this.context = context;
    // first reset app bloc context
    appBloc.resetContext.add(context);

    loadData.add(null); // Load the data
  }

  /// 
  /// Section: Private Methods
  /// 
  
  /// Connect to the service
  Future<void> connectToService() async {
    try {
      await _platform.invokeMethod<void>('connect');
      _connectedToService = true; // Set the flag
    } on Exception catch (e, st) {
      _connectedToService = false; // Reset the flag
      appBloc.showApiServiceError.add(Tuple2(e, st)); // Display Error
      return;
    }
  }

  /// Method to get the Image data in byte arrays
  void _getImageArrayBytes(void event) async {

    List<Uint8List> imageByteArrayResult = List<Uint8List>();

    final appBloc = AppProvider.of(context); // Get the application provider   

    try {
      // Connect to the service, if not connected
      if (!_connectedToService) await connectToService();
     
      // All good, now raise a call to get the data with the required arguments
      List<dynamic> imagesByteArrayData = await _platform.invokeMethod<List<dynamic>>('getImagesByteArrayData', 
      {"imageURLs" : _getImageUrls()});

      // Convert to the Uint8List format in an order to make it work with MemoryImage widget
      imagesByteArrayData.forEach((imageByte) {
        imageByteArrayResult.add(Uint8List.fromList(imageByte));
      });
      
    } on Exception catch (e, st) {
        appBloc.showApiServiceError.add(Tuple2(e, st)); // Display Error
    } 
    
    // Add data to the Sink 
    _imagesDataSubject.add(imageByteArrayResult);
  }

  // Get the random image URL's
  List<String> _getImageUrls() {
    const int NumberOfRequiredImages = 4;
    List<String> imageUrls = new List<String>();

    // Create random image URL list
    for (int index=0; index < NumberOfRequiredImages; index++) {
        imageUrls.add("https://picsum.photos/id/" + _next() + "/200/300");
    }

    return imageUrls;
  }

 // Generates a positive random integer uniformly distributed on the range
 // from [min], to [max]
  String _next({int min = 803, int max = 811}) {
    final _random = new Random();
    return (min + _random.nextInt(max - min)).toString();
  }

  // Toggles the media player play mode
  void _toggleMediaPlayer (void event) async {
    try {
        // Connect to the service, if not connected
        if (!_connectedToService) await connectToService();

        // Toggle the play service
        await _platform.invokeMethod<void>('toggleMediaPlayer');
      } on Exception catch (e, st) {
        appBloc.showApiServiceError.add(Tuple2(e, st)); // Display Error
    } 
  }
}


