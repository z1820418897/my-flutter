class Photo{
  int photoId;
  String path;
  num date;

  bool select=false;//界面中是否被选中了

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['photoId'] = photoId;
    map['path'] = path;
    map['date'] = date;
    return map;
  }

  static Photo fromMap(Map<String, dynamic> map) {
    Photo user = new Photo();
    user.photoId = map['photoId'];
    user.path = map['path'];
    user.date = map['date'];
    return user;
  }


  static List<Photo> fromMapList(dynamic mapList) {
    List<Photo> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

}