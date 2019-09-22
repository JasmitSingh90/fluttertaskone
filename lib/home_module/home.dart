import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'home_bloc.dart';
import 'home_provider.dart';

class HomePage extends StatefulWidget {
  final HomeBloc homeBloc;

  HomePage({
    @required this.homeBloc,
  }) : assert(homeBloc != null);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.homeBloc.setContext(context);

    return HomeProvider(
        homeBloc: widget.homeBloc,
        child: StreamBuilder<String>(
          stream: widget.homeBloc.imageData,
          builder: (context, snapshot) {
            return Scaffold(
              body: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: (!snapshot.hasData || snapshot.data == null)
                    ? Text(
                        "Error :(",
                        style: TextStyle(fontSize: 20),
                      )
                    : _buildBody(snapshot.data),
              ),
            );
          }
        )
    );
  }

  /// Widget to display the image
  Widget _buildBody(String snapshotData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Data:------------------------------->',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          snapshotData.toString(),
          style: TextStyle(fontSize: 12),
        ),
        RaisedButton(
          onPressed: () => widget.homeBloc.loadData.add(null),
          child: Text('Get Images', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
