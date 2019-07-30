import 'package:flutter/material.dart';
import 'package:flutter_demo/page/web/WebPage.dart';
import 'package:flutter_demo/tools/ZDialog.dart';

import 'config/QRCodeCardPage.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            //标题
            Container(
                margin: EdgeInsets.only(left: 20.0, top: 40.0, bottom: 5.0),
                child: Text(
                  "个人中心",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                )),
            //头像
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 50,
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "昵称：郑华晨",
                        style: TextStyle(
                            wordSpacing: 6,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 50,
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "账号：12345678910",
                        style: TextStyle(
                            wordSpacing: 6,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 50,
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "个性签名：只有大地知道落叶是在寻找家",
                        style: TextStyle(
                            wordSpacing: 6,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),

//                CircleAvatar(
//                  radius: 60.0,
//                  backgroundImage: AssetImage(
//                    "asset/image/bg_pg_login.jpg",
//                  ),
//                ),
                //图像图片
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                  child: Transform(
                    transform: Matrix4.rotationZ(0.15),
                    alignment: Alignment.center,
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Colors.orange,
                      child: Image.asset(
                        "asset/image/bg_pg_login.jpg",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 30.0,
            ),

            //选项列表
            InkWell(
              onTap: (){
                Toast.toast(context, "你好世界");
              },
              child: ListTile(
                leading: Icon(
                  Icons.ac_unit,
                  size: 30.0,
                ),
                title: Text(
                  "修改昵称",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text("郑华晨"),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 40.0,
                ),
              ),
            ),

            //选项列表
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> QRCodeCardPage()));
              },
              child: ListTile(
                leading: Icon(
                  Icons.ac_unit,
                  size: 30.0,
                ),
                title: Text(
                  "二维码名片",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text("生成自己的二维码名片"),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 40.0,
                ),
              ),
            ),


            ListTile(
              leading: Icon(
                Icons.ac_unit,
                size: 30.0,
              ),
              title: Text(
                "修改密码",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text("需要输入旧密码"),
              trailing: Icon(
                Icons.chevron_right,
                size: 40.0,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.ac_unit,
                size: 30.0,
              ),
              title: Text(
                "个性签名",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text("只有大地知道落叶是在寻找家"),
              trailing: Icon(
                Icons.chevron_right,
                size: 40.0,
              ),
            ),

            Container(
              height: 30.0,
            ),

            ListTile(
              leading: Icon(
                Icons.ac_unit,
                size: 30.0,
              ),
              title: Text(
                "绑定手机",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text("13723056700"),
              trailing: Icon(
                Icons.chevron_right,
                size: 40.0,
              ),
            ),

            ListTile(
              leading: Icon(
                Icons.ac_unit,
                size: 30.0,
              ),
              title: Text(
                "绑定邮箱",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text("1820418897@163.com"),
              trailing: Icon(
                Icons.chevron_right,
                size: 40.0,
              ),
            ),

            Container(
              height: 30.0,
            ),

            ListTile(
              leading: Icon(
                Icons.ac_unit,
                size: 30.0,
              ),
              title: Text(
                "版本更新",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text("v-1.0.0"),
              trailing: Icon(
                Icons.chevron_right,
                size: 40.0,
              ),
            ),

            InkWell(
              child: ListTile(
                leading: Icon(
                  Icons.ac_unit,
                  size: 30.0,
                ),
                title: Text(
                  "帮助指南",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 40.0,
                ),
              ),
              onTap: () {

              },
            ),

            InkWell(
              child: ListTile(
                leading: Icon(
                  Icons.ac_unit,
                  size: 30.0,
                ),
                title: Text(
                  "保修条约",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 40.0,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WebPage(),
                  ),
                );
              },
            ),

            Container(
              padding: EdgeInsets.only(top: 50.0, bottom: 30.0),
              alignment: Alignment.center,
              child:
                  Text("智能猫眼", style: TextStyle(fontWeight: FontWeight.w300)),
            ),
          ],
        ),
      ),
    );
  }
}
