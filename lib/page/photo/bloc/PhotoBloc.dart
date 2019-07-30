import 'package:flutter_demo/database/model/Photo.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class PhotoBloc{

  PhotoBloc(){
    _isEdit=false;
    _EditController=BehaviorSubject<bool>();

    _data={};
    _dataController= PublishSubject<List<List<Photo>>>();

    _delData={};
  }
  ///销毁
  dispose(){
    _EditController.close();
    _dataController.close();

  }

  ///编辑状态
  bool _isEdit;
  BehaviorSubject<bool> _EditController;
  bool get isEdit =>_isEdit;
  Stream<bool> get editStream =>_EditController.stream;

  //更新状态
  updateIsEdit(){
    _isEdit=!_isEdit;
    _EditController.add(_isEdit);
  }


  ///数据状态
  Map<String, List<Photo>> _data ;
  PublishSubject<List<List<Photo>>> _dataController;
  Stream<List<List<Photo>>> get dataStream => _dataController.stream;
  Map<String, List<Photo>> get data => _data;


  //刷新选中状态
  updateData(int index,Photo photo){
    var key = DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(photo.date));
    var data = _data[key];
    data.fillRange(index + 1, index + 1, photo);
    _data[key]=data;
  }

  //清空数据
  dataClear(){
    _data.clear();
  }

  //添加数据并通知监听者
  addData(List list){
    if (list.length > 0) {
      list.forEach((photos) {
        Photo photo = Photo.fromMap(photos);
        var date = photo.date;
        var key = DateFormat('yyyy-MM-dd')
            .format(DateTime.fromMillisecondsSinceEpoch(date));
        var value = _data[key];
        if (value == null) {
          value = List<Photo>();
          value.add(photo);
          _data[key] = value;
        } else {
          value.add(photo);
        }
      });
    }

    _dataController.add(_data.values.toList());

  }

  ///要删除的数据
  Map<int, Photo> _delData;
  Map<int, Photo> get delData => _delData;

  //清空数据
  delDataClear(){
    _data.clear();
  }
  //添加数据
  addDelData(int key,Photo data){
    _delData[key]=data;
  }
  //删除数据
  remDelData(int key){
    _delData.remove(key);
  }


}