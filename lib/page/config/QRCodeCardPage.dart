import 'package:flutter/material.dart';
import 'package:flutter_demo/tools/Zwidget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeCardPage extends StatefulWidget {
  @override
  _QRCodeCardPageState createState() => _QRCodeCardPageState();
}

class _QRCodeCardPageState extends State<QRCodeCardPage> {
  Zwidget zw;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    zw = Zwidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: zw.ZText("二维码名片"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 45.0),
            child: zw.ZCard(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15.0,top: 15.0),
                    child: ListTile(
                      title: zw.ZText("郑华晨",25.0,FontWeight.w600),
                      subtitle: zw.ZText("ID:147258369789456"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: QrImage(
                      data: "aaa",
                      onError: (ex) {
                        print("[QR] ERROR - $ex");
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    alignment: Alignment.center,
                    child: zw.ZText("扫一扫上面的二维码，分享设备给我",12.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
