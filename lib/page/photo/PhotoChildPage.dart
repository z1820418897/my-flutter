import 'package:flutter/material.dart';
import 'package:flutter_demo/database/model/Photo.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class PhotoChildPage extends StatefulWidget {
  final List<Photo> data;
  final int index;

  ///构造函数
  PhotoChildPage(this.data, this.index);

  @override
  _PhotoChildPageState createState() => _PhotoChildPageState();
}

//MediaQuery.of(context).size.width
class _PhotoChildPageState extends State<PhotoChildPage> {
  PublishSubject<int> dateController = PublishSubject();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: const FractionalOffset(0.05, 0.05),
        children: <Widget>[
          Swiper(
            itemCount: widget.data.length,
            index: widget.index,
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(
                "asset/image/bg_pg_login.jpg",
                fit: BoxFit.fill,
              );
            },
            pagination: SwiperPagination(margin: EdgeInsets.all(5.0)),
            onIndexChanged: (index) {
              dateController.add(index);
            },
//          control: SwiperControl(),
          ),
          Container(
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                StreamBuilder<int>(
                  stream: dateController.stream,
                  initialData: widget.index,
                  builder: (context, async) {
                    return Text(
                      "${DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.fromMillisecondsSinceEpoch(widget.data[async.data].date))}",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
