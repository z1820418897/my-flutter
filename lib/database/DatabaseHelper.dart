import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/Photo.dart';

class DatabasePhotoHelper {
  static final DatabasePhotoHelper _instance = DatabasePhotoHelper.internal();
  factory DatabasePhotoHelper() => _instance;
  final String tableName = "table_photo";
  final String columnId = "photoId";
  final String columnPath = "path";
  final String columnDate = "date";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabasePhotoHelper.internal();

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sqlite.db');
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  //创建数据库表
  void _onCreate(Database db, int version) async {
    await db.execute(
        "create table $tableName($columnId integer primary key autoincrement,$columnPath text not null ,$columnDate integer not null );");
    print("Table is created");
  }


//插入
  Future<int> saveItem(Photo photo) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", photo.toMap());
    print(res.toString());
    return res;
  }

  //查询所有
  Future<List> getTotalList() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName ORDER BY date DESC");
    print(result);
    return result.toList();
  }

  //查询总数
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $tableName"
    ));
  }

  //按照id查询
  Future<Photo> getItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id ");
    if (result.length == 0) return null;
    return Photo.fromMap(result.first);
  }


  //清空数据
  Future<int> clear() async {
    var dbClient = await db;
    return await dbClient.delete(tableName);
  }


  //根据id删除
  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName,
        where: "$columnId = ?", whereArgs: [id]);

  }


  Future<int> deleteList(List ids) async {

    String sid="0";

    ids.forEach((id)=> sid = sid +",$id");

    var dbClient = await db;
    return await dbClient.rawDelete("delete from $tableName where $columnId in ($sid)");
  }





  //修改
  Future<int> updateItem(Photo photo) async {
    var dbClient = await db;
    return await dbClient.update("$tableName", photo.toMap(),
        where: "$columnId = ?", whereArgs: [photo.photoId]);
  }




  //关闭
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}