import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_demo/socket/SocketController.dart';
import 'package:flutter_demo/socket/SocketData.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';

class MainPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainPageState();
  }
}



//什么请求都没有
class MainPageState extends State<MainPage> {

  final StreamController streamController = StreamController.broadcast();
  final List list=SocketDataUtil().headToData(DataHead(123123123, 18, 123, 1));
  final StreamController loginController=StreamController();

  MainPageState(){
    SocketController().messageFactory.register(3306, loginController);
  }

  int i=0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder(
                  stream: loginController.stream,
                  initialData:"没数据",
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    return Text('接收到数据: ${snapshot.data}');
                  }
              ),
              StreamBuilder(
                  stream: streamController.stream,
                  initialData:"没数据",
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    return Text('接收到数据: ${snapshot.data}');
                  }
              ),
              Container(
                child: RaisedButton(
                    child: Text("你好世界"),
                    onPressed: (){
                      streamController.sink.add("123 ${i++}");
                      //streamController.close();
                    }
                ),
              ),
              Container(
                child: RaisedButton(
                    child: Text("世界你好"),
                    onPressed: () {
                      print(list);
                      SocketController().sendData(list);
                      //streamController.close();
                    }
                ),
              ),
              Image.network(
                  "http://img1.imgtn.bdimg.com/it/u=980639442,3686180993&fm=26&gp=0.jpg"
                  )

            ],
          ),
        ),
      ),
    );
  }
}

//tcp请求

class MainPageTcpState extends State<MainPage> {
  //static Socket socket;
  bool isConn = false;

//  Future<Socket> getConn() async{
//      if(isConn){
//        print("已经连接到服务器");
//        return;
//      }
//
//      return await Socket.connect("10.10.2.179", 12345,timeout:Duration(seconds: 5)).
//      then((Socket sock){
//        socket=sock;
//        isConn = true;
//        socket.transform(Utf8Decoder()).listen(
//          dataHandler,
//          onError:errorHandler,
//          onDone:doneHandler,
//          cancelOnError:false,
//        );
//      }).catchError((e){
//        print("数据监听出错");
//        print(e);
//        getConn();
//      });
//  }

  Socket socket;
  static bool isSocketConn = false;

  static Future<Socket> getConn() async {
    Future<Socket> future=Future(()=>null);


    return await Socket.connect("10.10.2.179", 12345,
            timeout: Duration(seconds: 5))
        .catchError((e) {
      print("无法连接服务器，请检查网络设置");
      isSocketConn = false;
    });
  }

  static void lisendData() {
    Future<Socket> future = getConn();
    future.then((Socket socket) {
      socket.listen(dataHandler);
    });
  }

  static void dataHandler(data) {
    print("---------------------------接收到消息了----------------------------");
    print(data);
  }

  void errorHandler(error, StackTrace trace) {
    print("socket报错了");
    print(error);
    doneHandler();
  }

  void doneHandler() {
    print("socket错误，重置");
    socket.destroy();
    getConn();
  }

  void sendData(Uint8List dataList) async {
    print("==================================发送数据===========================");
    await socket.add(dataList);
    print("==================================发送完成==============");
    await socket.flush();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("连接socket"),
              onPressed: lisendData,
            ),
            RaisedButton(
              child: Text("发送测试数据"),
              onPressed: () {
                print("我要发送数据");
              },
            ),
            RaisedButton(
              child: Text("断开连接"),
              onPressed: doneHandler,
            ),
          ],
        ),
      ),
    );
  }
}

//dio包 http请求
class _MainPageHttpDioState extends State<MainPage> {
  var result;

  void getData() async {
    Dio dio = Dio();
    var response = await dio.get('http://10.10.2.179:32515/CatEye/test');
    setState(() {
      result = response.data.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("$result" == null ? "暂无数据" : "$result"),
            RaisedButton(
              child: Text("获取接口"),
              onPressed: getData,
            ),
          ],
        ),
      ),
    );
  }
}

//http请求 使用http包
class _MyHomePageState extends State<MainPage> {
  var result;

  _loadData_http_get() async {
    print('------loadData_http_get--------');
    var client = http.Client();
    http.Response response =
        await client.get('http://10.10.2.179:32515/CatEye/test');
    setState(() {
      if (response.statusCode == HttpStatus.ok) {
        print(response.body);
        print('请求失败 code 码为${response.statusCode}');
        result = response.body;
      } else {
        result = response.statusCode;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);

    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('Your current IP address is:'),
            new Text('$result'),
            spacer,
            new RaisedButton(
              onPressed: _loadData_http_get,
              child: new Text('Get IP address'),
            ),
          ],
        ),
      ),
    );
  }
}
