import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Zwidget{

  //加粗的文字
  Widget ZText(String text,[double size=24.0,FontWeight w=FontWeight.w500]){

    return Text(text,style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(size),fontWeight: w),);
  }

  //通用的卡片
  Widget ZCard({Widget child}){
    return Card(
      elevation: 5.0,
      shape: const RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(10.0))),
      child: child,
    );
  }


}






