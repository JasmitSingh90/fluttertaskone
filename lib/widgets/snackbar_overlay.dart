import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_one/util/translations.dart';
import '../theme/theme.dart' as theme;
import 'button_flat.dart';

class SnackbarOverlayHandler {
  final BuildContext context;

  OverlayState _overlayState;
  OverlayEntrySafeRemove _currentOverlayEntry;
  bool _isOverlayDisplayed = false;

  SnackbarOverlayHandler({
    @required this.context,
  })  : assert(context != null) {
    _overlayState = Overlay.of(context);
  }

  /// Will display snackbar overlay (1 at a time).
  ///
  /// autoDismiss: is set to false by default, and will display for 2 secs only
  showSnackbarOverlay({
    String message,
    double bottomOffset = 0.0,
    bool autoDismiss = false,
    Duration autoDismissDuration = const Duration(seconds: 4)
  }) async {
    // we close any existing overlay
    if (_isOverlayDisplayed && _currentOverlayEntry != null) _currentOverlayEntry.remove();

    final overlayEntry = OverlayEntrySafeRemove(
        builder: (context) => SnackbarOverlay(
              message: message,
              bottomOffset: bottomOffset,
              onDismiss: () {
                if(_currentOverlayEntry != null) {
                  _currentOverlayEntry.remove();
                }
                _isOverlayDisplayed = false;
              },
            ));
    _currentOverlayEntry = overlayEntry;
    _overlayState.insert(_currentOverlayEntry);
    _isOverlayDisplayed = true;


    // if we need to autoDismiss after we waiting for x seconds
    if (autoDismiss) {
      await new Future.delayed(autoDismissDuration);

      // if the overlayEntry we created above is still not removed
      // then we remove it
      // if the _currentOverlayEntry is the one we created, then we
      // considered there is no overlay displayed
      if (overlayEntry != null && overlayEntry.removed == false) {
        overlayEntry.remove();
        if(overlayEntry == _currentOverlayEntry) {
          _isOverlayDisplayed = false;
          _currentOverlayEntry = null;
        }
      }
    }
  }
}

class SnackbarOverlay extends StatefulWidget {
  final String message;
  final VoidCallback onDismiss;
  final double bottomOffset;

  SnackbarOverlay({
    @required this.message,
    @required this.onDismiss,
    this.bottomOffset = 0.0,
  })  : assert(message != null),
        assert(onDismiss != null);

  @override
  _SnackbarOverlayState createState() => _SnackbarOverlayState();
}

class _SnackbarOverlayState extends State<SnackbarOverlay> {
  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    bottomPadding = bottomPadding > 0.0 ? bottomPadding : 20.0;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, bottomPadding + widget.bottomOffset),
        child: _buildCard(),
      ),
    );
  }

  Widget _buildCard() {
    return Material(
      type: MaterialType.card,
      color: theme.kColorBlack,
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildMessage(),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage() {
    return Expanded(
      child: AutoSizeText(
        widget.message,
        maxLines: 2,
        style: Theme.of(context).textTheme.body1.copyWith(
          color: theme.kColorWhite,
        )
      ),
    );
  }

  Widget _buildButton() {
    return ButtonFlat(
      onPressed: widget.onDismiss,
      child: Text(
        Translations.of(context).text('button_dismiss'),
        style: TextStyle(color: theme.kColorLightBlue),
      ),
    );
  }
}

///
/// https://github.com/flutter/flutter/issues/30479
class OverlayEntrySafeRemove extends OverlayEntry {

  bool removed = false;
  OverlayEntrySafeRemove({
    WidgetBuilder builder,
    bool opaque = false,
    bool maintainState = false,
  }) : super(builder: builder, opaque: opaque, maintainState: maintainState);

  @override
  void remove() {
    if(!removed) {
      super.remove();
      removed = true;
    }
  }
}
