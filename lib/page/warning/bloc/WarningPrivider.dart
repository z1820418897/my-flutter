
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/photo/bloc/PhotoBloc.dart';

import 'WarningBloc.dart';

class WarningProvider extends InheritedWidget {

  final WarningBloc bloc;

  WarningProvider({Key key,Widget child,this.bloc}):super(key : key,child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static WarningBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(WarningProvider) as WarningProvider).bloc;
}