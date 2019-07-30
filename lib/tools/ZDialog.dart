import 'package:flutter/material.dart';

import 'Zwidget.dart';

//等待log
class LoadingDialog extends Dialog {
  String text;

  LoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      //这是一个透明层
      type: MaterialType.transparency, //透明层类型
      child: Center(
        child: SizedBox(
          width: 120.0,
          height: 120.0,
          child: Container(
            decoration: ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//消息log
class MessageDialog extends Dialog {
  String title;
  String message;
  String negativeText;
  String positiveText;
  Function onCloseEvent;
  Function onPositivePressEvent;

  MessageDialog({
    Key key,
    @required this.title,
    @required this.message,
    this.negativeText,
    this.positiveText,
    this.onPositivePressEvent,
    @required this.onCloseEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              margin: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: <Widget>[
                        Center(
                          child: new Text(
                            title,
                            style: new TextStyle(
                              fontSize: 19.0,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: this.onCloseEvent,
                          child: new Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: new Icon(
                              Icons.close,
                              color: Color(0xffe0e0e0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Color(0xffe0e0e0),
                    height: 1.0,
                  ),
                  Container(
                    constraints: BoxConstraints(minHeight: 180.0),
                    child: new Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: new IntrinsicHeight(
                        child: new Text(
                          message,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                  this._buildBottomButtonGroup(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonGroup() {
    var widgets = <Widget>[];
    if (negativeText != null && negativeText.isNotEmpty)
      widgets.add(_buildBottomCancelButton());
    if (positiveText != null && positiveText.isNotEmpty)
      widgets.add(_buildBottomPositiveButton());
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: new Flex(
        direction: Axis.horizontal,
        children: widgets,
      ),
    );
  }

  Widget _buildBottomCancelButton() {
    return new Flexible(
      fit: FlexFit.tight,
      child: new FlatButton(
        onPressed: onCloseEvent,
        child: new Text(
          negativeText,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPositiveButton() {
    return new Flexible(
      fit: FlexFit.tight,
      child: new FlatButton(
        onPressed: onPositivePressEvent,
        child: new Text(
          positiveText,
          style: TextStyle(
            color: Color(Colors.teal.value),
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

//使用toast
class Toast {
  static OverlayEntry _overlayEntry; //toast靠它加到屏幕上
  static bool _showing = false; //toast是否正在showing
  static DateTime _startedTime; //开启一个新toast的当前时间，用于对比是否已经展示了足够时间
  static String _msg;
  static void toast(
      BuildContext context,
      String msg,
      ) async {
    assert(msg != null);
    _msg = msg;
    _startedTime = DateTime.now();
    //获取OverlayState
    OverlayState overlayState = Overlay.of(context);
    _showing = true;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
            //top值，可以改变这个值来改变toast在屏幕中的位置
            top: MediaQuery.of(context).size.height * 2 / 3,
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80.0),
                  child: AnimatedOpacity(
                    opacity: _showing ? 1.0 : 0.0, //目标透明度
                    duration: _showing
                        ? Duration(milliseconds: 100)
                        : Duration(milliseconds: 400),
                    child: _buildToastWidget(),
                  ),
                )),
          ));
      overlayState.insert(_overlayEntry);
    } else {
      //重新绘制UI，类似setState
      _overlayEntry.markNeedsBuild();
    }
    await Future.delayed(Duration(milliseconds: 2000)); //等待两秒

    //2秒后 到底消失不消失
    if (DateTime.now().difference(_startedTime).inMilliseconds >= 2000) {
      _showing = false;
      _overlayEntry.markNeedsBuild();
    }
  }

  //toast绘制
  static _buildToastWidget() {
    return Center(
      child: Card(
        color: Colors.black26,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Text(
            _msg,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}