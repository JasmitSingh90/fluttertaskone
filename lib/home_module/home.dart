import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_task_one/home_module/support/home_image_tile.dart';
import 'package:flutter_task_one/home_module/support/home_loader.dart';
import 'package:flutter_task_one/home_module/support/home_media_button.dart';
import 'package:flutter_task_one/util/translations.dart';

import 'home_bloc.dart';
import 'home_provider.dart';

class HomePage extends StatefulWidget {
  final HomeBloc homeBloc;
  final String title;

  HomePage({
    Key key,
    this.title,
    @required this.homeBloc,
  })  : assert(homeBloc != null),
        super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  AnimationController controller;
  bool isContextSet = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    controller.addListener(() {
      setState(() {
        // Refresh the data when the value is 100 percent
        if (controller.value == 1) { 
          controller.value = 0; // Reset the controller value
          widget.homeBloc.loadData.add(null);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Reset the flag to reconnect the service when resumed
      widget.homeBloc.setIsConnectedToService.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set the context and get the data
    if (!isContextSet) {
      isContextSet = true;
      widget.homeBloc.setContext(context);
    }

    return HomeProvider(
      homeBloc: widget.homeBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _buildBody(),
        floatingActionButton: HomePageMediaButton(),
      )
    );
  }

  Widget _buildBody() {
    return Stack(
      alignment: Alignment.center, 
      children: <Widget>[
      Container(
        child: StreamBuilder<bool>(
          stream: widget.homeBloc.isInErrorState,
          initialData: false,
          builder: (context, snapdata) {
          return Container(
          child: (snapdata.data) ? Text (Translations.of(context).text('message_something_went_wrong')) :
            Container(
              child: StreamBuilder<List<Uint8List>>(
              stream: widget.homeBloc.imagesData,
              builder: (context, snapshot) {
                return Container(
                  decoration: BoxDecoration(color: Colors.black12),
                  child: (snapshot.data == null) ? 
                    Center(
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(Translations.of(context).text('message_please_wait')
                          )
                      )
                    ): (snapshot.hasData && (snapshot.data.length == 0)) ? Text (Translations.of(context).text('message_something_went_wrong')) : 
                     _buildContent(snapshot.data)
                  );
                }
              )
            )
            );
          }
        )
      ),
      (controller.value > 0) 
        ? HomeLoadingButton(controller) : Container(),
    ]);
  }

  Widget _buildContent(List<Uint8List> byteArrayData) {
    return GestureDetector(
      onLongPressStart: (_) => controller.forward(),
      onLongPressEnd: (_) {
        if (controller.status ==
            AnimationStatus.forward) {
          controller.reverse();
        }
      },
      child:Column(children: <Widget>[
        Expanded(
          child: GridView.count(
          crossAxisCount: 2,
          children: byteArrayData
              .map((data) => ImageTile(
                    byteArrayData: data,
                  ))
              .toList(),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        )),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(bottom: 30.0, left: 20.0),
            child: Text(
              Translations.of(context).text('message_hold_refresh'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontStyle: FontStyle.italic
              )
            )
          )
        )
      ])
    );
  }
}
