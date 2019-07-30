
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/photo/bloc/PhotoBloc.dart';

class PhotoProvider extends InheritedWidget {

  final PhotoBloc bloc;

  PhotoProvider({Key key,Widget child,this.bloc}):super(key : key,child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }


  static PhotoBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(PhotoProvider) as PhotoProvider).bloc;
}