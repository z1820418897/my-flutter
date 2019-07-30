class CallerBean{

  int _dId;
  int _cId;
  String _time;
  String _url;

  CallerBean(this._dId, this._cId, this._time,this._url);

  String get time => _time;

  int get cId => _cId;

  int get dId => _dId;

  String get url => _url;

}