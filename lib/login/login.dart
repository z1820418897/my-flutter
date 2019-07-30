import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_demo/main/main.dart';
import 'package:flutter_demo/page/index.dart';
import 'package:flutter_demo/socket/SocketController.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {



//  LoginPage(){
//    SocketController().socketConn();
//  }

  @override
  State<StatefulWidget> createState() {


    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  TextEditingController t_user = TextEditingController();
  TextEditingController t_pwd = TextEditingController();
  bool b_user = false;
  bool b_pwd = false;



  void _login() {
    print({'user': t_user.text, 'pwd': t_pwd.text});
    Navigator.push(
      context,
     MaterialPageRoute(builder: (context) => IndexPage(),)
    );
//    if (!t_user.text.endsWith("zhenghuachen")) {
//      showDialog(
//          context: context,
//          builder: (context) => AlertDialog(
//                title: Text("请输入正确的账号"),
//              ));
//    } else if (!t_pwd.text.endsWith("19980803")) {
//      showDialog(
//          context: context,
//          builder: (context) => AlertDialog(
//                title: Text("密码是我生日"),
//              ));
//    } else {
//      t_user.clear();
//      t_pwd.clear();
//      Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => MainPage(),),
//      );
//    }
  }    

  void _textChange_user(String str) {
    setState(() {
      if (str.length == 12) {
        b_user = true;
      } else {
        b_user = false;
      }
    });
  }

  void _textChange_pwd(String str) {
    setState(() {
      if (str.length == 8) {
        b_pwd = true;
      } else {
        b_pwd = false;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: window.physicalSize.width, height: window.physicalSize.height, allowFontScaling: true)..init(context);

    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('asset/image/bg_pg_login.jpg'),
            ),
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  color: Color.fromARGB(50, 255, 230, 230)),
              width: 350.0,
              height: 350.0,
              child: LoginFrom(),
            ),
          ),
        ),
      );
  }

  //登录表单
  Column LoginFrom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        UserItem(),
        Container(
          height: 40.0,
        ),
        PwdItem(),
        Container(
          height: 40.0,
        ),
        LoginItem(),
      ],
    );
  }

  //-------列表item
  //用户名框
  Container UserItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 45.0,
      child: TextField(
        controller: t_user,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.phone_iphone),
          suffixIcon: b_user
              ? Icon(
                  Icons.beenhere,
                  color: Colors.green,
                )
              : Icon(Icons.cancel),
          labelText: '请输入用户名',
        ),
        autofocus: false,
        onChanged: _textChange_user,
      ),
    );
  }

  //密码框
  Widget PwdItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 45.0,
      child: TextField(
        controller: t_pwd,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.lock),
          suffixIcon: b_pwd
              ? Icon(
                  Icons.beenhere,
                  color: Colors.green,
                )
              : Icon(Icons.cancel),
          labelText: '请输入密码',
        ),
        obscureText: true,
        onChanged: _textChange_pwd,
      ),
    );
  }

  //登录按钮
  Container LoginItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      width: double.infinity,
      height: 45.0,
      child: OutlineButton(
        borderSide: BorderSide(color: Colors.lightBlue),
        child: Container(child: Text('登录')),
        onPressed: _login,
      ),
    );
  }
}
