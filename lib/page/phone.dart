import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PhonePage extends StatefulWidget {
  String rtmpPath;

  PhonePage({int pid = 0}) {
    this.rtmpPath =
    "https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.MP4";
//        "rtsp://admin:gcdev12345@10.10.2.170:554/h264/ch1/main/av_stream";
//    this.rtmpPath="xxxx${pid}";
  }

  @override
  PhonePageState createState() => PhonePageState();
}

class PhonePageState extends State<PhonePage> {
//  ///截图控制
//  GlobalKey rootWidgetKey = GlobalKey();
//  _capturePng() async {
//    try {
//      Directory appDocDir = await getExternalStorageDirectory();
//      String appDocPath = appDocDir.path;
//      final imageFile = File(path.join(appDocPath, 'dart.png'));
//
//      RenderRepaintBoundary boundary = rootWidgetKey.currentContext.findRenderObject();
//
//      var image = await boundary.toImage(pixelRatio: window.devicePixelRatio);
//
//      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
//      Uint8List pngBytes = byteData.buffer.asUint8List();
//
//      showDialog(context: context,child: Container(child:Text("${pngBytes}"),),);
//      await imageFile.writeAsBytes(pngBytes);
//
//    } catch (e) {
//      print(e);
//    }
//  }




  ///ijk控制器
  IjkMediaController _controller = IjkMediaController();

  ///静音按钮控制
  StreamController<bool> _mutuController = StreamController<bool>();

  ///静音标记
  bool isMutu;

  ///计时器
  StreamController<String> _timerController = StreamController<String>();
  Timer _timer;
  int _countTime = 0;

  ///静音状态按钮样式和控制
  Widget mutuStyle(isMutu) {
    if (isMutu) {
      return InkWell(
          child: Image.asset("asset/button/mutu.png"),
          onTap: () {
            _mutuController.sink.add(isMutu ? false : true);
            isMutu = !isMutu;
            _controller.volume = 100;
          });
    } else {
      return InkWell(
          child: Image.asset("asset/button/nomutu.png"),
          onTap: () {
            _mutuController.sink.add(isMutu ? false : true);
            isMutu = !isMutu;
            _controller.volume = 0;
          });
    }
  }

  ///启动定时器
  void _startTimer() {

    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _countTime++;
      int s = _countTime % 60;
      int m = _countTime ~/ 60;
      m = m >= 60 ? 0 : m;
      int h = (_countTime ~/ 60) ~/ 60;

      String ss = s > 9 ? "$s" : "0$s";
      String sm = m > 9 ? "$m" : "0$m";
      String sh = h > 9 ? "$h" : "0$h";

      _timerController.sink.add("${sh}:${sm}:${ss}");


    });
  }

  ///初始化
  @override
  void initState() {

    super.initState();
    initIjk();

  }

  ///初始化ijk
  void initIjk() async {
    //设置ijk的参数
    var options = Set<IjkOption>();
    // 播放前的探测时间
    options.add(IjkOption(IjkOptionCategory.format, "analyzeduration", 1));
    // 播放前最大探测时间
    options.add(IjkOption(IjkOptionCategory.format, "analyzemaxduration", 100));
    // 播放前的探测size，默认是1M, 改小一点会出画面更快
    options.add(IjkOption(IjkOptionCategory.format, "probesize", 256));
    // 0: 软解码(默认)；1：硬解码。
    options.add(IjkOption(IjkOptionCategory.player, "videotoolbox", 0));
    // 无限读取
    options.add(IjkOption(IjkOptionCategory.player, "infbuf", 1));
    // 最大缓冲大小(单位kb)
    options.add(IjkOption(IjkOptionCategory.player, "max-buffer-size", 0));

    options
        .add(IjkOption(IjkOptionCategory.player, "max_cached_duration", 500));
    // 不额外优化
    options.add(IjkOption(IjkOptionCategory.player, "fast", 1));
    // 开启环路滤波（0比48清晰，但解码开销大，48基本没有开启��路滤波，清���度低，解码开销小）
    options.add(IjkOption(IjkOptionCategory.codec, "skip_loop_filter", 8));

    // 是否开启预缓冲��一般直播��目会开启，达到秒开的效果，不过带来了播放丢帧卡顿的体验
    options.add(IjkOption(IjkOptionCategory.player, "packet-buffering", 0));
    // 如果项目中多次调用播放器，有网络视频，rtsp，本地视频，还有wifi上http视频，所以得清空DNS才能播放WIFI上的视频
    options.add(IjkOption(IjkOptionCategory.player, "dns_cache_clear", 1));

    _controller.setIjkPlayerOptions(
      [TargetPlatform.iOS, TargetPlatform.android],
      options,
    );

    await _controller.setNetworkDataSource(widget.rtmpPath,
//        "https://video.pearvideo.com/mp4/third/20190629/cont-1571778-11308777-200151-hd.mp4",
//        'https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.MP4',
//         'rtmp://172.16.100.245/live1',
        // 'https://www.sample-videos.com/video123/flv/720/big_buck_bunny_720p_10mb.flv',
//         "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
        // 'http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8',
        // "file:///sdcard/Download/Sample1.mp4",
//        "rtsp://admin:gcdev12345@10.10.2.170:554/h264/ch1/main/av_stream"
        autoPlay: true);
  }

  ///截图保存
  printScreen() async{

//  getExternalStorageDirectory();getApplicationDocumentsDirectory
    Directory appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir.path;
    final imageFile = File(path.join(appDocPath, 'dart.jpg'));
//    Directory(appDocDir.path+"/photo");

    var uint8List= await _controller.screenShot();
    showDialog(context: context,child: Container(child:Text("${uint8List}"),),);
    await imageFile.writeAsBytes(uint8List);

    print("图片保存成功");
  }


  ///页面销毁
  @override
  void dispose() {
    _controller.dispose();
    _timerController.close();
    _timer.cancel();
    super.dispose();
  }

  ///bulid方法
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:  _buildIjkPlayer(),
      ),
    );
  }

  ///视屏播放视图
  Widget _buildIjkPlayer() {
    return IjkPlayer(
      mediaController: _controller,
      controllerWidgetBuilder: (mediaController) {
        return _buildIjkController();
      },

      textureBuilder:(context,mediaController,videoInfo){
        return DefaultIJKPlayerWrapper(
            controller: mediaController,
            info: videoInfo,
          ); // 默认纹理界面
      },
//      textureBuilder:(context,mediaController,videoInfo){
//        return RepaintBoundary(
//          key: rootWidgetKey,
//          child: Texture(
//            textureId: _controller.textureId,
//          ),
//        );// 自定义纹理界面
//      },
      statusWidgetBuilder: _buildStatusWidget,
    );
  }

  ///界面控制
  Widget _buildIjkController() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "正在通话中",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              child: StreamBuilder<String>(
                  stream: _timerController.stream,
                  initialData: "00:00:00",
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return Text(
                      "${snapshot.data}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400),
                    );
                  }),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ///静音
                      Expanded(
                        child: InkWell(
                          child: StreamBuilder<bool>(
                            stream: _mutuController.stream,
                            initialData: false,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              return mutuStyle(snapshot.data);
                            },
                          ),
                        ),
                      ),

                      ///挂断
                      Expanded(
                        child: InkWell(
                          child: Image.asset("asset/button/over.png"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),

                      ///截图
                      Expanded(
                        child: InkWell(
                          child: Image.asset("asset/button/camera.png"),
                          onTap: () async{
                            printScreen();
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: RaisedButton(
                      onPressed: () {},
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 100.0, vertical: 10.0),
                          child: Text("按住讲话")),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///状态控制
  Widget _buildStatusWidget(
    BuildContext context,
    IjkMediaController controller,
    IjkStatus status,
  ) {
    if (status == IjkStatus.noDatasource) {
      print("noDatasource--------------------------------");
    } else if (status == IjkStatus.disposed) {
      print("disposed--------------------------------");
    } else if (status == IjkStatus.complete) {
      print("complete--------------------------------");
    } else if (status == IjkStatus.preparing) {
      print("preparing--------------------------------");
    } else if (status == IjkStatus.prepared) {
      print("prepared--------------------------------");
    } else if (status == IjkStatus.error) {
      print("error--------------------------------");
    } else if (status == IjkStatus.pause) {
      print("pause--------------------------------");
    } else if (status == IjkStatus.playing) {
      print("playing--------------------------------");
      _startTimer();
    } else if (status == IjkStatus.setDatasourceFail) {
      print("setDatasourceFail-------------------------");
    }
    // you can custom your self status widget
    //return IjkStatusWidget.buildStatusWidget(context, controller, status);
    return null;
  }

}





class IJKPlayerWrapper extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }


}





class DefaultIJKPlayerWrapper extends StatelessWidget {
  final IjkMediaController controller;
  final VideoInfo info;

  const DefaultIJKPlayerWrapper({
    Key key,
    this.controller,
    this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double ratio = info?.ratio ?? 1280 / 720;

    var id = controller.textureId;

    if (id == null) {
      return AspectRatio(
        aspectRatio: ratio,
        child: Container(
          color: Colors.black,
        ),
      );
    }

    Widget w = Container(
      color: Colors.black,
      child: Texture(
        textureId: id,
      ),
    );

    if (!controller.autoRotate) {
      return w;
    }

    int degree = info?.degree ?? 0;

    if (ratio == 0) {
      ratio = 1280 / 720;
    }

    w = AspectRatio(
      aspectRatio: ratio,
      child: w,
    );

    if (degree != 0) {
      w = RotatedBox(
        quarterTurns: degree ~/ 90,
        child: w,
      );
    }

    return Container(
      child: w,
      alignment: Alignment.center,
      color: Colors.black,
    );
  }
}