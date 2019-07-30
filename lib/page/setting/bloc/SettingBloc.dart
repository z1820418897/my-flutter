

import 'package:rxdart/rxdart.dart';

class SettingBloc{

  SettingBloc(){
    //数据初始化 以后要从内存 或数据库中初始化 保持数据的持久性
    _WarningState=false;
    _WarningStateController=BehaviorSubject();

    _RingState=0;
    _RingStateController=BehaviorSubject();

    _VolumeState=false;
    _VolumeStateController=BehaviorSubject();

     _Volume=80;
    _VolumeController=BehaviorSubject();

    _disturbState=false;
    _disturbStateController=BehaviorSubject();

    _weeks=[false,false,false,false,false,true,true,];
    _weeksController=BehaviorSubject();

    _beginTime=[0,0,0];
    _overTime=[23,59,59];
    _dateController=BehaviorSubject();

  }

  dispose(){
    _WarningStateController.close();
    _RingStateController.close();
    _VolumeStateController.close();
    _VolumeController.close();
    _weeksController.close();
    _disturbStateController.close();
    _dateController.close();
  }

  ///报警设置
  bool _WarningState;
  BehaviorSubject _WarningStateController;
  Stream get mWarningStream =>_WarningStateController.stream;
  bool get mWarningState =>_WarningState;

  setWarningState(state){
    _WarningState=state;
    _WarningStateController.add(state);
  }
  ///铃声设置
  int _RingState;

  BehaviorSubject _RingStateController;
  Stream get mRingStream => _RingStateController.stream;
  int get mRingState=>_RingState;

  setRingState(state){
    _RingState=state;
    _RingStateController.add(state);
  }

  ///音量设置
  bool _VolumeState;
  BehaviorSubject _VolumeStateController;
  Stream get mVolumeStateStream => _VolumeStateController.stream;
  bool get mVolumeState=>_VolumeState;

  setVolumeState(state){
    _VolumeState=state;
    _VolumeStateController.add(state);
  }

  ///音量控制
  int _Volume;
  BehaviorSubject _VolumeController;
  Stream get mVolumeStream => _VolumeController.stream;
  int get mVolume=>_Volume;

  setVolume(state){
    _Volume=state;
    _VolumeController.add(state);
  }



  ///免打扰控制
  bool _disturbState;
  BehaviorSubject _disturbStateController;
  Stream get mDisturbStream=>_disturbStateController.stream;
  bool get disturbState=> _disturbState;

  setDisturbState(state){
    _disturbState=state;
    _disturbStateController.add(state);
  }



  ///日期选择控制
  List<bool> _weeks;
  List<bool> get mWeeks => _weeks;
  BehaviorSubject _weeksController;
  Stream get mWeekStream => _weeksController.stream;

  setWeeks(state,index){
    _weeks[index]=state;
    print(_weeks[index]);
    _weeksController.add(_weeks);

  }


  ///时间选择状态
  List<int> _beginTime;
  List<int> _overTime;
  List<int> get mbeginTime => _beginTime;
  List<int> get mOverTime => _overTime;

  BehaviorSubject _dateController;
  Stream get mDateStream => _dateController.stream;

  setDate(DateType type,List<int> date){
    switch(type){
      case DateType.begin:
        _beginTime=date;
        break;
      case DateType.over:
        _overTime=date;
        break;
    }
    _dateController.add(date);
  }
}


enum DateType{
  begin,
  over,
}