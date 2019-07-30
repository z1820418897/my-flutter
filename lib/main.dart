import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'login/login.dart';

void main() {
  requestPermission();

  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: LoginPage(),
      )
  );

}

Future requestPermission() async {

  // 申请权限
  Map<PermissionGroup, PermissionStatus> permissions =
  await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  // 申请结果
  PermissionStatus permission =
  await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  if (permission == PermissionStatus.granted) {
    print("权限通过");
  } else {
    print("权限被拒绝");
  }
}




