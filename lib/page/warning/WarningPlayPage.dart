import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class WarningPlayPage extends StatelessWidget {

  final List<String> data;

  WarningPlayPage(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: const FractionalOffset(0.0, 0.05),
        children: <Widget>[

          Swiper(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(
                "asset/image/bg_pg_login.jpg",
                fit: BoxFit.fill,
              );
            },
            pagination: SwiperPagination(margin: EdgeInsets.all(5.0)),
            onIndexChanged: (index) {

            },
//          control: SwiperControl(),
          ),

          Container(
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    size: 45.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
