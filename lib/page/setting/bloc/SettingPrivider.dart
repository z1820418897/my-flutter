import 'package:flutter/cupertino.dart';

import 'SettingBloc.dart';

class SettingPrivider extends InheritedWidget {

  final SettingBloc bloc;

  SettingPrivider({Key key,Widget child,this.bloc}):super(key : key,child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static SettingBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(SettingPrivider) as SettingPrivider).bloc;
}