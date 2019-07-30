import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demo/page/phone.dart';
import 'package:flutter_demo/page/photo/PhotoPage.dart';
import 'package:flutter_demo/page/setting/SettingPage.dart';
import 'package:flutter_demo/page/warning/WarningPage.dart';
import 'package:flutter_demo/socket/SocketController.dart';
import 'package:flutter_demo/tools/Zwidget.dart';

import 'caller/CallerPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DevicePage extends StatefulWidget {
  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  Zwidget zw;

  final StreamController cradsController = StreamController();

  //页面
  PageController _pageController = PageController();

  //下标
  int _pageIndex = 0;

  //定义卡片列表
  List cards = List();

  //初始化方法
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    zw = Zwidget();
    SocketController().messageFactory.register(3307, cradsController);
    //cradsController.add([1,2,3,4,5]);
  }

  ///自定义的滑动指示控件
  Widget _CradBar(int index) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        width: 25.0,
        height: 5.0,
        child: Card(
          color: _pageIndex == index ? Colors.lightBlue : Colors.black45,
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        ));
  }

  ///卡片内容
  Widget _CardView() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 45.0, horizontal: 30),
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            child: Column(
              children: <Widget>[
                buildDeviceImg(),
                buildPower(),
                buildBtnGroup(),
              ],
            ),
          ),
        ));
  }

  ///卡片右边的按钮组
  Expanded buildBtnGroup() {
    return Expanded(
      flex: 2,
      child: Row(
        children: <Widget>[
          bulidInfoGroup(),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: buildCardItem("报警记录", () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => WarningPage()));
                          }),
                        ),
                        Expanded(
                          child: buildCardItem("访客记录", () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CallerPage()));
                          }),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: buildCardItem("本地抓拍", () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PhotoPage()));
                          }),
                        ),
                        Expanded(
                          child: buildCardItem("设置", () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SettingPage()));
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///卡片右边的单个按钮
  Container buildCardItem(String title, Function fun) {
    return Container(
      child: GestureDetector(
        child: Card(
          elevation: 5.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Icon(
                  Icons.ac_unit,
                  size: 30,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: zw.ZText(title),
              )
            ],
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))), //设置圆角
        ),
        onTap: () {
          print("你好世界");
          fun();
        },
      ),
    );
  }

  ///电量进度条
  Container buildPower() {
    return Container(
      child: LinearProgressIndicator(
        value: 85 / 100.0,
      ),
    );
  }

  ///卡片上方设备图片
  Expanded buildDeviceImg() {
    return Expanded(
      flex: 3,
      child: Stack(
        alignment: const FractionalOffset(0.5, 0.5),
        children: <Widget>[
          Container(
            //                          constraints: BoxConstraints.expand(
            //                            height:Theme.of(context).textTheme.display1.fontSize * 2,
            //                          ),
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('asset/image/bg_pg_login.jpg'),
              ),
            ),
          ),
          GestureDetector(
            child: Icon(
              Icons.phone,
              color: Colors.greenAccent,
              size: 80,
            ),
            onTap: () {
              print("打电话");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PhonePage(pid: 100)));
            },
          ),
        ],
      ),
    );
  }

  ///卡片左边的列表
  Expanded bulidInfoGroup() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: Column(
          children: <Widget>[
            Expanded(child: buildInfo(Icon(Icons.phone_iphone), "当前状态", "在线")),
            Expanded(child: buildInfo(Icon(Icons.beenhere), "人体报警", "打开")),
            Expanded(child: buildInfo(Icon(Icons.home), "空气温度", "30℃")),
            Expanded(child: buildInfo(Icon(Icons.ac_unit), "空气湿度", "80%")),
          ],
        ),
      ),
    );
  }

  ///卡片的左边信息item
  Container buildInfo(Icon icon, String title, String info) {
    return Container(
      child: Row(
        children: <Widget>[
          icon,
          zw.ZText("$title:",14,FontWeight.w600),
          zw.ZText("$info",14,FontWeight.w600),
        ],
      ),
    );
  }

  ///右上角菜单键1 添加设备 2分享设备
  selectMenu(int id) {
    if (id == 1) {
      print("添加设备");
    } else if (id == 2) {
      print("分享设备");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("我的设备"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (int id) {
                selectMenu(id);
              },
              itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                    PopupMenuItem(
                      value: 1,
                      child: Text("添加设备"),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text("分享设备"),
                    ),
                  ],
            ),
          ],
        ),
        body: StreamBuilder(
            stream: cradsController.stream,
            initialData: [1, 2, 3],
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.data);
              cards = snapshot.data;
              return Stack(
                alignment: const FractionalOffset(0.5, 0.97),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: cards.length,
                            onPageChanged: (pageIndex) {
                              setState(() {
                                _pageIndex = pageIndex;
                                print(_pageController.page);
                                print(pageIndex);
                              });
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return _CardView();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    //width: cards.length*20.0,
                    height: 5.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: cards.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _CradBar(index);
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
