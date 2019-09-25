import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeLoadingButton extends StatelessWidget {
  final AnimationController controller;

  HomeLoadingButton(this.controller);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.black38,
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Stack(alignment: Alignment.center, children: <Widget>[
          CircularProgressIndicator(
            value: 1.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
          CircularProgressIndicator(
            value: controller.value,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          Icon(Icons.refresh, color: Colors.white,)
        ]),
      )
    );
  }
}
