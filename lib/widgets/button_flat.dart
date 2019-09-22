import 'package:flutter/material.dart';

class ButtonFlat extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final EdgeInsetsGeometry padding;

  ButtonFlat({
    @required this.onPressed,
    @required this.child,
    this.padding,
  })  : assert(child != null);

  ButtonFlat.icon({
    @required this.onPressed,
    @required Widget icon,
    @required Widget label,
  })  : assert(icon != null),
        assert(label != null),
        padding = const EdgeInsetsDirectional.only(start: 12.0, end: 16.0),
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            icon,
            const SizedBox(width: 8.0),
            label
          ],
        );

  @override
  Widget build(BuildContext context) {
    return _buildFlatButton();
  }

  Widget _buildFlatButton() {
    return FlatButton(
      onPressed: onPressed,
      padding: padding,
      child: child,
    );
  }
}