class WarningBean{
  int _dId;
  int _wId;
  String _time;
  int _type;//1 图片 2 视频
  List<String> _data;//每条记录中的所有地址

  WarningBean(this._dId, this._wId, this._time, this._type,
      this._data);

  List<String> get data => _data;

  int get type => _type;

  String get time => _time;

  int get wId => _wId;

  int get dId => _dId;


}