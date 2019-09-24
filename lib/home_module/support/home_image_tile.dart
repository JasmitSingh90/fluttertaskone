import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageTile extends StatelessWidget {
  
  final Uint8List byteArrayData;

  ImageTile({
    @required this.byteArrayData
  });

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: const Color(0x00000000),
      elevation: 3.0,
      child: new GestureDetector(
        onTap: () => null,
        child: new Container(
            decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new MemoryImage(byteArrayData),
            fit: BoxFit.cover,
          ),
          borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
        )),
      ),
    );
  }
}