import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/page/user.dart';
import 'device.dart';
//http://img5.mtime.cn/mg/2019/06/19/225542.25716835_285X160X4.jpg

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}


class _IndexPageState extends State<IndexPage> {

  //声明底部菜单栏
  final List<BottomNavigationBarItem> bottomTabs=[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text("主页")
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.info_outline),
      title: Text("信息")
    ),
  ];

  //声明页面
  final List tabBodies=[
    DevicePage(),
    UserPage(),
  ];

  int currentIndex=0;//定义当前索引
  var currentPage;//定义当前的界面


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPage=tabBodies[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(244, 245, 245, 1),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            items: bottomTabs,
            onTap: (index){
              setState(() {
                currentIndex=index;
                currentPage=tabBodies[index];
              });
            },
        ),
      body: currentPage,
    );
  }
}

