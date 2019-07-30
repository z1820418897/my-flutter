import 'dart:async';
import 'dart:io';

import 'MessageFactory.dart';
import 'SocketConf.dart';

///TCP socket套接字的控制类
class SocketController {

  ///初始化socketController
  SocketController._();
  static SocketController _instance = SocketController._();
  factory SocketController() => _instance;

  ///打印日志
  String TAG = "SocketController";

  ///定义套接字
  Socket socket;

  ///消息监听工厂
  final MessageFactory messageFactory=MessageFactory();

  ///连接服务器
  Future socketConn() async {
    try {
      socket = await Socket.connect(
          SocketConf.SOCKET_IP, SocketConf.SOCKET_PROT,
          timeout: Duration(seconds: SocketConf.SOCKET_TIMEOUT_S));
      socket.listen(onData,onError: onError,onDone: onDone,cancelOnError: false);
    } catch (e) {
      print("TAG:连接不上服务器\n $e");
    }
  }

  ///接收数据
  onData(data){

      print("TAG: $data");
      //解析数据 粘包

      //·············待处理

      int cmd=3306;
      messageFactory.find(cmd).sink.add(data);

  }

  ///错误处理
  onError(e){
      print("TAG: 估计是超时了 $e");
  }

  ///执行结束或中断
  onDone(){

      print("TAG: 执行结束或中断");

  }

  ///发送数据
  sendData (List list) {
    print(socket);
    //分包·············待处理
    socket.add(list);
  }


}
