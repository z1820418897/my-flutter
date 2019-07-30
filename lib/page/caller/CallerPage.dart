import 'package:flutter/material.dart';
import 'package:flutter_demo/provider/BlocProvider.dart';
import 'package:flutter_demo/tools/ZCalendar.dart';
import 'package:flutter_demo/tools/ZDialog.dart';
import 'package:flutter_demo/tools/Zwidget.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

import 'bean/CallerBean.dart';
import 'bloc/CallerBloc.dart';

class CallerPage extends StatefulWidget {
  @override
  _CallerPageState createState() => _CallerPageState();
}

class _CallerPageState extends State<CallerPage> {
  Zwidget zw; //自定义样式控件
  CallerBloc bloc; //bloc状态控制

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    zw = Zwidget();
    bloc = CallerBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CallerBloc>(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: buildTitle(),
          actions: <Widget>[
            buildVisibilityBtn(),
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(padding: EdgeInsets.symmetric(vertical: 10.0),child: StreamBuilder(
              stream: bloc.mDateStream,
              initialData: bloc.mDate,
              builder: (context, snapshot) {
                return zw.ZText(snapshot.data);
              }
            ),),
            buildCalendar(),
            Expanded(child: buildGridView()),
            buildCountInfo(),
          ],
        ),
      ),
    );
  }


  ///标题
  Text buildTitle() => Text("访客记录");

  ///日历控制显示按钮
  StreamBuilder buildVisibilityBtn() {
    return StreamBuilder(
        stream: bloc.mCalendarVisibilityStream,
        initialData: bloc.mCalendarVisibility,
        builder: (context, snapshot) {
          return IconButton(
            icon: Icon(snapshot.data
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down),
            onPressed: () {
              bloc.updateCalendarVisibility();

            },
          );
        });
  }

  
  ///创建日历
  StreamBuilder buildCalendar() {
    return StreamBuilder(
        stream: bloc.mCalendarVisibilityStream,
        initialData: bloc.mCalendarVisibility,
        builder: (context, snapshot) {
          return Visibility(
            visible: snapshot.data,
            child: Container(
              child: ZCalendar(
                initSelect: bloc.mDateTime,
                valueChanged: (date) {
                  bloc.updateData(date.year,date.month,date.day);
                  bloc.updateDate(date.year,date.month,date.day);
                },
              ),
            ),
          );
        });
  }

  ///图片数据列表
  StreamBuilder buildGridView() {
    return StreamBuilder(
      stream: bloc.mDataStream,
      initialData: bloc.mData,
      builder: (context, snapshot) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
          child: GridView.builder(
            itemCount: snapshot.data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //横轴元素个数
              crossAxisCount: 3,
              //纵轴间距
              mainAxisSpacing: 10.0,
              //横轴间距
              crossAxisSpacing: 10.0,
              //子组件宽高长度比例
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              return BuildGridViewItem(snapshot.data[index]);
            },
          ),
        );
      }
    );
  }

  ///当天记录条数显示
  Container buildCountInfo() {
    return Container(padding: EdgeInsets.symmetric(vertical: 10.0),child: StreamBuilder(
        stream: bloc.mDataStream,
        initialData: bloc.mData,
        builder: (context, snapshot) {
          return zw.ZText("${snapshot.data.length}条记录");
        }
    ),);
  }

}


//每个图片是一个小界面 应该有自己的状态控制 当然可以也可以通过bloc控制
class BuildGridViewItem extends StatefulWidget {
  CallerBean caller;
  BuildGridViewItem(this.caller);
  @override
  _BuildGridViewItemState createState() => _BuildGridViewItemState();
}
class _BuildGridViewItemState extends State<BuildGridViewItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Toast.toast(context, widget.caller.time);
      },

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
              image: AdvancedNetworkImage(
                widget.caller.url,
//                  header: header,//还可以携带参数
                useDiskCache: true,//开启图片缓存
                cacheRule: CacheRule(maxAge: const Duration(days: 3)),//缓存时间
              ),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
