import 'package:flutter_demo/page/warning/bean/WarningBean.dart';
import 'package:rxdart/rxdart.dart';

class WarningBloc{



  WarningBloc(){
    _CalendarVisibility=false;
    _CalendarVisibilityController=BehaviorSubject();


    _dateTime = DateTime.now();
    _Date="${_dateTime.year}年${_dateTime.month}月${_dateTime.day}日";
    _DateController=BehaviorSubject();

    //模拟数据
    _Warning = [
      WarningBean(1, 20190716115523, "2019-12-15 11:50:23", 1, ["", "", ""]),
      WarningBean(2, 20190716115525, "2019-12-15 11:51:25", 1, ["", "", ""]),
      WarningBean(3, 20190716115526, "2019-12-15 11:51:35", 2, [""]),
      WarningBean(4, 20190716115528, "2019-12-15 11:52:40", 2, [""]),
    ];
    for(int i=0;i<30;i++){
      _Warning.add(WarningBean(i+4, 20190716115529+i, "2019-12-15 11:50:23", 1, ["", "", ""]));
    }

    _WarningController=BehaviorSubject();

    _Edit=false;
    _EditController=BehaviorSubject();


    _DeleteWarning={};
  }

  dispose(){
    _CalendarVisibilityController.close();
    _DateController.close();
    _WarningController.close();
    _EditController.close();
  }

//控制日历显示
  bool _CalendarVisibility;
  bool get mCalendarVisibility => _CalendarVisibility;
  BehaviorSubject _CalendarVisibilityController;
  Stream get mCalendarVisibilityStream => _CalendarVisibilityController.stream;
  void updateCalendarVisibility(){
    _CalendarVisibility=!_CalendarVisibility;
    _CalendarVisibilityController.add(_CalendarVisibility);
  }


  //控制时间刷新
  String _Date;
  String get mDate=> _Date;

  //时间格式化
  DateTime _dateTime;
  get mDateTime=> _dateTime;

  BehaviorSubject _DateController;
  Stream get mDataStream=>_DateController.stream;

  updateDate(int year,int month,int day){
    _dateTime=DateTime(year,month,day);
    _Date="$year年$month月$day日";
    _DateController.add(_Date);


    //-------------------------------------------
    _Warning = [
      WarningBean(1, 20190716115523, "$year-$month-$day 11:50:23", 1, ["", "", ""]),
      WarningBean(2, 20190716115525, "$year-$month-$day 11:51:25", 1, ["", "", ""]),
      WarningBean(3, 20190716115526, "$year-$month-$day 11:51:35", 2, [""]),
      WarningBean(4, 20190716115528, "$year-$month-$day 11:52:40", 2, [""]),
    ];
    updateWarning(_Warning);

  }


  //记录列表
  List<WarningBean> _Warning;
  get mWarning => _Warning;
  BehaviorSubject _WarningController;
  get mWarningStream=> _WarningController.stream;

  updateWarning(list){
    _Warning=list;
    _WarningController.add(list);
  }

  clearWarning(){
    _Warning.clear();

    //调用网络接口后 去掉 数据从网络接口刷新
    updateWarning(_Warning);
  }

  deleteWarning(){
    _DeleteWarning.forEach((key,value){
      _Warning.remove(value);
    });

    //调用网络接口后 去掉 数据从网络接口刷新
    updateWarning(_Warning);
  }

  //编辑模式
  bool _Edit;
  get mEdit => _Edit;
  BehaviorSubject _EditController;
  get mEditStream => _EditController.stream;


  updateEdit(){
    _Edit=!_Edit;
    _EditController.add(_Edit);
    if(_Edit){
      if(_CalendarVisibility){
        updateCalendarVisibility();
      }

    }else{

      clearDeleteWarning();
    }

  }


  //选中和删除
  Map<int,WarningBean> _DeleteWarning;
  get mDeleteWarning => _DeleteWarning;



  addDeleteWarning(WarningBean bean){
    _DeleteWarning[bean.wId]=bean;
  }

  removeDeleteWarning(WarningBean bean){
    _DeleteWarning.remove(bean.wId);
  }

  //清空以后 要通知所有的选项 改变图标状态 颜色  不能太通过自身的setstate

  clearDeleteWarning(){
    _DeleteWarning.clear();
    //调用网络接口后 去掉 数据从网络接口刷新
    updateWarning(_Warning);
  }

  //判断是否选中
  bool isSelct (int key){
    return _DeleteWarning.containsKey(key);
  }



}