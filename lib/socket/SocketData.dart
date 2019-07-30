import 'dart:typed_data';
import 'dart:convert';

class SocketDataUtil {

  ///将String转换成二进制
  List stringToData(String str) {
    return utf8.encode(str);
  }

  ///将int转化成n字节
  Uint8List intToUint8(int i, int n) {
    var byteData = ByteData(n);

    switch(n){
      case 2:
        byteData.setUint16(0, i);
        break;
      case 4:
        byteData.setUint32(0, i);
        break;
      case 8:
        byteData.setUint64(0, i);
        break;
    }

    return byteData.buffer.asUint8List(0, n);
  }


  ///拼装数据包头
  List headToData(DataHead dataHead) {
    //假设包头协议为

    List list=intToUint8(dataHead.msgId,8) +
        intToUint8(dataHead.length,4) +
        intToUint8(dataHead.cmd,4) +
        intToUint8(dataHead.msgVersion,2);

    return list;
  }


}

//实体类
class DataHead {
  int msgId;
  int length;
  int cmd;
  int msgVersion;
  DataHead(this.msgId,this.length,this.cmd,this.msgVersion);
}
