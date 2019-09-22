import 'package:flutter/widgets.dart';
import 'home_bloc.dart';

class HomeProvider extends InheritedWidget {
  final HomeBloc homeBloc;

  HomeProvider({
    Key key,
    @required this.homeBloc,
    Widget child,
  })  : assert(homeBloc != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static HomeBloc of(BuildContext context) => 
    (context.inheritFromWidgetOfExactType(HomeProvider) as HomeProvider)
      .homeBloc;
}