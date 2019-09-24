import 'package:flutter/material.dart';

import '../home_bloc.dart';
import '../home_provider.dart';

class HomePageMediaButton extends StatefulWidget {
  @override
  HomePageMediaButtonState createState() {
    return new HomePageMediaButtonState();
  }
}

class HomePageMediaButtonState extends State<HomePageMediaButton> {
  bool _showPlayIconAndHint = false;

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
    final homeBloc = HomeProvider.of(context);

    return FloatingActionButton(
        onPressed: () => _toggleMediaPlayerIcon(homeBloc),
        tooltip: (_showPlayIconAndHint) ? 'Pause the music' : 'Play the music',
        child: (_showPlayIconAndHint)
            ? Icon(Icons.pause)
            : Icon(Icons.play_arrow));
  }

  void _toggleMediaPlayerIcon(HomeBloc homeBlc) {
    setState(() {
      _showPlayIconAndHint = !_showPlayIconAndHint;
      homeBlc.toggleMediaPlayer.add(null);
    });
  }
}
