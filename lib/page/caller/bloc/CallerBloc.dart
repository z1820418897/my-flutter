import 'package:flutter_demo/page/caller/bean/CallerBean.dart';
import 'package:flutter_demo/provider/BlocProvider.dart';
import 'package:rxdart/rxdart.dart';

class CallerBloc implements BlocBase {
  @override
  void dispose() {
    _CalendarVisibilityController.close();
  }

  CallerBloc() {
    _CalendarVisibility = false;
    _CalendarVisibilityController = BehaviorSubject();

    _dateTime = DateTime.now();
    _Date="${_dateTime.year}年${_dateTime.month}月${_dateTime.day}日";
    _DateController=BehaviorSubject();

    _Data=[
      CallerBean(1,1,"2018-9-15 16:15:30","https://image14.m1905.cn/uploadfile/2016/1222/thumb_1_150_203_20161222085501454891.jpg"),
      CallerBean(1,2,"2018-9-15 16:15:35","https://image13.m1905.cn/uploadfile/2017/0831/thumb_1_150_203_20170831020816158604.jpg"),
      CallerBean(1,3,"2018-9-15 16:15:36","https://image11.m1905.cn/uploadfile/2017/0322/thumb_1_150_203_20170322035532164848.jpg"),
      CallerBean(1,4,"2018-9-15 16:15:39","https://image13.m1905.cn/uploadfile/2018/0522/thumb_1_150_203_20180522114946371455.jpg"),
      CallerBean(1,5,"2018-9-15 16:15:58","https://image11.m1905.cn/uploadfile/2014/1229/thumb_1_150_203_20141229085724522834.jpg"),
      CallerBean(1,6,"2018-9-15 16:15:52","https://image14.m1905.cn/uploadfile/2013/0526/thumb_1_150_203_20130526062923742.jpg"),
      CallerBean(1,7,"2018-9-15 16:15:55","http://image11.m1905.cn/uploadfile/s2010/0107/thumb_1_150_203_20100107113740792.jpg"),
      CallerBean(1,8,"2018-9-15 16:15:45","http://image11.m1905.cn/uploadfile/2009/1106/thumb_1_150_203_20091106111848318.jpg"),
      CallerBean(1,9,"2018-9-15 16:15:55","http://image11.m1905.cn/uploadfile/2015/0626/thumb_1_150_203_20150626063948762035.jpg"),
    ];
    _DataController=BehaviorSubject();
  }

  ///显示状态控制
  bool _CalendarVisibility;

  bool get mCalendarVisibility => _CalendarVisibility;
  BehaviorSubject _CalendarVisibilityController;

  Stream get mCalendarVisibilityStream => _CalendarVisibilityController.stream;

  Sink get mCalendarVisibilitySink => _CalendarVisibilityController.sink;

  void updateCalendarVisibility() {
    _CalendarVisibility = !_CalendarVisibility;
    mCalendarVisibilitySink.add(_CalendarVisibility);
  }

  ///数据控制
  List<CallerBean> _Data;
  BehaviorSubject _DataController;

  Stream get mDataStream => _DataController.stream;

  Sink get mDataSick => _DataController.sink;

  List<CallerBean> get mData => _Data;

  void updateData(int year,int month,int day){
    _Data=[CallerBean(1,9,"2018-9-15 16:15:55","http://image11.m1905.cn/uploadfile/2015/0626/thumb_1_150_203_20150626063948762035.jpg")];
    mDataSick.add(_Data);
  }


  ///控制时间刷新
  String _Date;
  String get mDate=> _Date;

  ///时间格式化
  DateTime _dateTime;
  get mDateTime=> _dateTime;

  BehaviorSubject _DateController;
  Stream get mDateStream=>_DateController.stream;

  void updateDate(int year,int month,int day){
    _dateTime=DateTime(year,month,day);
    _Date="$year年$month月$day日";
    _DateController.add(_Date);
  }



}
