import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class WarningVideoPage extends StatefulWidget {
  List<String> data;

  WarningVideoPage(this.data);

  @override
  _WarningVideoPageState createState() => _WarningVideoPageState();
}

class _WarningVideoPageState extends State<WarningVideoPage> {
  IjkMediaController _controller = IjkMediaController();

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

    await _controller.setNetworkDataSource(
        "https://video.pearvideo.com/mp4/third/20190629/cont-1571778-11308777-200151-hd.mp4",
//        'https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.MP4',
//         'rtmp://172.16.100.245/live1',
        // 'https://www.sample-videos.com/video123/flv/720/big_buck_bunny_720p_10mb.flv',
//         "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
        // 'http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8',
        // "file:///sdcard/Download/Sample1.mp4",
//        "rtsp://admin:gcdev12345@10.10.2.170:554/h264/ch1/main/av_stream"
        autoPlay: true);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initIjk();
//    widget.data[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: const FractionalOffset(0.00, 0.05),
        children: <Widget>[
          Container(
            child: _buildIjkPlayer(),
          ),
          Container(
            child: IconButton(icon: Icon(Icons.chevron_left,size: 45.0,color: Colors.white,), onPressed: (){
              Navigator.pop(context);
            }),
          ),
        ],
      ),
    );
  }


  ///视屏播放视图
  Widget _buildIjkPlayer() {
    return IjkPlayer(
      mediaController: _controller,
    );
  }






  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
