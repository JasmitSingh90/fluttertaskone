import 'package:flutter/widgets.dart';
import 'app_bloc.dart';

class AppProvider extends InheritedWidget {
  final AppBloc appBloc;

  AppProvider({
    Key key,
    @required this.appBloc,
    Widget child,
  })  : assert(appBloc != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AppBloc of(BuildContext context) => 
    (context.inheritFromWidgetOfExactType(AppProvider) as AppProvider)
      .appBloc;
}