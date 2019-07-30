import 'package:flutter_demo/tools/ZDialog.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/database/DatabaseHelper.dart';
import 'package:flutter_demo/database/model/Photo.dart';
import 'package:intl/intl.dart';

import 'package:flutter_demo/page/photo/bloc/PhotoBloc.dart';
import 'package:flutter_demo/page/photo/bloc/PhotoPrivider.dart';

import 'PhotoChildPage.dart';

//抓拍记录界面
class PhotoPage extends StatefulWidget {
  @override
  _PhotoPageState createState() => _PhotoPageState();



}

class _PhotoPageState extends State<PhotoPage> {

    PhotoBloc photoBloc;
    var db = DatabasePhotoHelper();

    //初始化
    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      //初始化bloc
      photoBloc = PhotoBloc();

      //初始化查询数据
      _query();

    }

    @override
    void dispose() {
      super.dispose();
      photoBloc.dispose();

    }



    //添加
    Future<Null> _add() async {
      Photo photo = new Photo();

//      var now = DateTime.parse('2019-06-15 10:30:30.888');
      var now = DateTime.now();
      photo.date = now.millisecondsSinceEpoch;

      photo.path = "a/a/a/";

      await db.saveItem(photo);

      _query();
    }

    //清空
    Future<Null> _clear() async {
      await db.clear();
      _query();
    }

    //查询
    Future<Null> _query() async {
      photoBloc.dataClear();
      List data = await db.getTotalList();
      photoBloc.addData(data);
    }

    //删除
    Future<Null> delete() async {

      if (photoBloc.delData.isNotEmpty) {
        //先删除图片文件

        //在删除数据库
        await db.deleteList(photoBloc.delData.keys.toList());
        photoBloc.delDataClear();

        _query();

      }

    }



    //加载
    @override
    Widget build(BuildContext context) {
      return PhotoProvider(
        bloc: photoBloc,
        child: Scaffold(
          appBar: AppBar(
            title: Text("抓拍记录"),
            actions: <Widget>[
              StreamBuilder<bool>(
                stream: photoBloc.editStream,
                initialData: false,
                builder: (context, async) {
                  return OutlineButton(
                    child: async.data ? Text("取消") : Text("编辑"),
                    onPressed: () {
                      photoBloc.updateIsEdit();

                    },
                  );
                },
              ),
            ],
          ),

          body: Container(
            child: StreamBuilder<List<List<Photo>>>(
              stream: photoBloc.dataStream,
              initialData: [],
              builder: (context,async) {
                return builderListView(async.data);
              },
            ),
          ),
          //底部删除按钮
          bottomSheet: StreamBuilder<bool>(
            stream: photoBloc.editStream,
            initialData: false,
            builder: (context, async) {
              return Visibility(
                visible: async.data,
                child: Container(
                  height: 45.0,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          child: Container(
                            child: Text(
                              "清空",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            alignment: Alignment.center,
                          ),
                          onTap: () {



                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
//                    return LoadingDialog(text: "请稍等···",);
                                return MessageDialog(
                                  title: "好心提醒",
                                  message: "你确定要清空吗？",
                                  positiveText: "确定",
                                  negativeText:"取消",
                                  onPositivePressEvent: (){
                                    _clear();
                                    Navigator.pop(context);
                                  },
                                  onCloseEvent: (){
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );

                          },
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                        width: 1.0,
                        child: Center(
                            child: Container(
                          color: Colors.lightBlue,
                        )),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Container(
                            child: Text(
                              "删除",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            alignment: Alignment.center,
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
//                    return LoadingDialog(text: "请稍等···",);
                                return MessageDialog(
                                  title: "好心提醒",
                                  message: "你确定要删除吗？",
                                  positiveText: "确定",
                                  negativeText:"取消",
                                  onPositivePressEvent: (){
                                    delete();
                                    Navigator.pop(context);
                                  },
                                  onCloseEvent: (){
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );

                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
  //        _clear();
              _add();
            },
          ),
        ),
      );
    }

    //listview列表 纵向列表
    Widget builderListView(List<List<Photo>> data) {
      if (data.length == 0) {
        return Center(child: Text("没有图片可以显示"));
      }

      return ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(data[i][0].date))}",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
                  ),
                  padding: EdgeInsets.only(top: 30.0, left: 10.0),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 30.0, bottom: 30.0, left: 15.0, right: 15.0),
                  child: builderGridView(data[i],i),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 50.0),
                  child: Text("${data[i].length}条记录"),
                ),
              ],
            ),
          );
        },
      );
    }

    //图片列表 九宫格
    Widget builderGridView(List list,int i) {

      return GridView.builder(
        itemCount: list.length,
        physics: new NeverScrollableScrollPhysics(),
        //增加
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //横轴元素个数
          crossAxisCount: 5,
          //纵轴间距
          mainAxisSpacing: 10.0,
          //横轴间距
          crossAxisSpacing: 10.0,
          //子组件宽高长度比例
          childAspectRatio: 0.8,
        ),
        itemBuilder: (BuildContext context, int index) {

  //    return Text("${list[index].path}");

          return GridViewItem(
            data: list[index],
            index: index,
    //  select: list[index],
          );
        },
      );
    }
}

class GridViewItem extends StatefulWidget {
  final Photo data;
  final int index;
  GridViewItem({Key key, this.data, this.index,this.onChanged}) : super(key: key);

  //回调 参数
  final ValueChanged<bool> onChanged;

  @override
  _GridViewItemState createState() => _GridViewItemState();
}

class _GridViewItemState extends State<GridViewItem> {
  bool select;
  PhotoBloc photoBloc;


  updateDel(select){
    if(select){
      photoBloc.addDelData(widget.data.photoId,widget.data);
    }else{
      photoBloc.remDelData(widget.data.photoId);
    }
  }


  @override
  Widget build(BuildContext context) {

    photoBloc = PhotoProvider.of(context);
    select=widget.data.select;

    return GestureDetector(
      onTap: () {
        if(photoBloc.isEdit){
          select = !select;
          widget.data.select=select;
          //photoBloc.updateData(widget.index,widget.data);
          updateDel(select);
          setState((){});
        }else{
          var key = DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(widget.data.date));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PhotoChildPage(photoBloc.data[key],widget.index),
            ),
          );
        }

        print(widget.data.select);
      },

      child: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                    image: AssetImage('asset/image/bg_pg_login.jpg'),
                    fit: BoxFit.cover)),
            ),
            StreamBuilder<bool>(
              stream: photoBloc.editStream,
              initialData: select,
              builder: (context,async){

                if(!async.data&&select){
                  select=false;
                  widget.data.select=select;
                  photoBloc.updateData(widget.index,widget.data);
                  updateDel(select);
                }

                return Visibility(
                  visible: select && async.data,
                  child: Container(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                );
              },
            ),


          ],
        ),
      ),
    );
  }
}
