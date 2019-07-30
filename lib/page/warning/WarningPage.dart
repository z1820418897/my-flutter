import 'package:flutter/material.dart';
import 'package:flutter_demo/tools/ZCalendar.dart';
import 'package:flutter_demo/tools/ZDialog.dart';
import 'package:flutter_demo/tools/Zwidget.dart';

import 'WarningPlayPage.dart';
import 'WarningVideoPage.dart';
import 'bean/WarningBean.dart';
import 'bloc/WarningBloc.dart';
import 'bloc/WarningPrivider.dart';

class WarningPage extends StatefulWidget {
  @override
  _WarningPageState createState() => _WarningPageState();
}

class _WarningPageState extends State<WarningPage> {
  WarningBloc bloc;
  Zwidget zw;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = new WarningBloc();
    zw = Zwidget();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WarningProvider(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text("报警记录"),
          actions: <Widget>[
            StreamBuilder(
                stream: bloc.mEditStream,
                initialData: bloc.mEdit,
                builder: (context, snapshot) {
                  return IconButton(
                    icon: Icon(snapshot.data ? Icons.check : Icons.select_all),
                    iconSize: 35.0,
                    onPressed: () {
                      bloc.updateEdit();
                    },
                  );
                }),
            StreamBuilder(
                stream: bloc.mCalendarVisibilityStream,
                initialData: false,
                builder: (context, snapshot) {
                  return StreamBuilder(
                      stream: bloc.mEditStream,
                      initialData: bloc.mEdit,
                      builder: (context, snap) {
                        return IconButton(
                          icon: Icon(snapshot.data
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down),
                          iconSize: 35.0,
                          onPressed: () {
                            if (!snap.data) {
                              bloc.updateCalendarVisibility();
                            }
                          },
                        );
                      });
                }),
          ],
        ),
        body: Column(
          children: <Widget>[
            buildCalendar(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: StreamBuilder(
                  stream: bloc.mDataStream,
                  initialData: bloc.mDate,
                  builder: (context, snapshot) {
                    return Container(
                        alignment: Alignment.center,
                        child: zw.ZText(snapshot.data));
                  }),
            ),


            Expanded(child: buildListView()),

            Center(
              child: StreamBuilder(
                stream: bloc.mWarningStream,
                  initialData: bloc.mWarning,
                builder: (context, snapshot) {
                  return Container(
                    padding: EdgeInsets.only(top: 20.0,bottom: 10.0),
                      child:zw.ZText("${bloc.mWarning.length}条记录"),
                  );
                }
              ),
            ),


            buildEditButton(),
          ],
        ),
      ),
    );
  }

  //底部按钮
  StreamBuilder buildEditButton() {
    return StreamBuilder(
              stream: bloc.mEditStream,
              initialData: bloc.mEdit,
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.data,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: zw.ZCard(
                              child: InkWell(
                            child: Container(
                              child: zw.ZText("清空所有"),
                              margin: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 50.0),
                            ),
                            onTap: () {
                              bloc.clearWarning();
                            },
                          )),
                        ),
                        Container(
                          child: zw.ZCard(
                              child: InkWell(
                            child: Container(
                              child: zw.ZText("删除选中"),
                              margin: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 50.0),
                            ),
                                onTap: (){
                                    if(bloc.mDeleteWarning.length>0){
                                      bloc.deleteWarning();
                                    }else{
                                      Toast.toast(context, "请先选择");
                                    }
                                },
                          )),
                        ),
                      ],
                    ),
                  ),
                );
              });
  }

  //创建日历
  StreamBuilder<Object> buildCalendar() {
    return StreamBuilder<Object>(
      stream: bloc.mCalendarVisibilityStream,
      initialData: false,
      builder: (context, snapshot) {
        print(bloc.mDateTime);
        return Visibility(
          visible: snapshot.data,
          child: Container(
            child: ZCalendar(
              initSelect: bloc.mDateTime,
              valueChanged: (date) {
                bloc.updateDate(date.year, date.month, date.day);
              },
            ),
          ),
        );
      },
    );
  }

  //创建列表
  StreamBuilder buildListView() {
    return StreamBuilder(
        stream: bloc.mWarningStream,
        initialData: bloc.mWarning,
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return WarningListViewItem(snapshot.data[index]);
            },
          );
        });
  }
}

class WarningListViewItem extends StatefulWidget {
  WarningBean data;

  WarningListViewItem(this.data);

  @override
  _WarningListViewItemState createState() => _WarningListViewItemState();
}

class _WarningListViewItemState extends State<WarningListViewItem> {
  Zwidget zw;
  WarningBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    zw = Zwidget();
  }

  @override
  Widget build(BuildContext context) {
    bloc = WarningProvider.of(context);
    return Container(
      child: zw.ZCard(
        child: ListTile(
          title: zw.ZText("${widget.data.time}"),
          subtitle:
              zw.ZText("消息类型:" + (widget.data.type == 1 ? "图片" : "视频"), 13.0),
          trailing: StreamBuilder(
              stream: bloc.mEditStream,
              initialData: bloc.mEdit,
              builder: (context, snapshot) {
                return Icon(
                  snapshot.data ? Icons.check_circle : Icons.chevron_right,

                  size: snapshot.data ? 25.0 : 40.0,

//                  color: Colors.blue.shade400,
                  color: bloc.isSelct(widget.data.wId)
                      ? Colors.blue.shade400
                      : Colors.grey,
                );
              }),
          onTap: () {
            if (!bloc.mEdit) {
              if (widget.data.type == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => WarningPlayPage(widget.data.data)),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => WarningVideoPage(widget.data.data)),
                );
              }
            } else {
              print("w我不是编辑模式");
              if (bloc.isSelct(widget.data.wId)) {
                bloc.removeDeleteWarning(widget.data);
              } else {
                bloc.addDeleteWarning(widget.data);
              }
              setState(() {});
            }
          },
        ),
      ),
    );
  }
}
