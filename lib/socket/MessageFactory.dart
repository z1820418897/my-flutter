import 'dart:async';
import 'dart:collection';

///消息仓库
class MessageFactory{

  final Map<int,StreamController> _messageFactory=LinkedHashMap<int,StreamController>();

  ///注册消息
  void register(int id,StreamController controller){
    _messageFactory[id]=controller;
  }

  ///删除消息
  void remove(int id){
    _messageFactory.remove(id);
  }

  ///根据key查询消息
  StreamController find(int id){

    return _messageFactory[id];
  }


  ///清空所有的消息
  void clear(){
    _messageFactory.clear();
  }


}
