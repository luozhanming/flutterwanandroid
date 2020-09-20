import 'package:sqflite/sqflite.dart';
import 'package:wanandroid/database/config.dart';
import 'package:wanandroid/model/user.dart';

class WanAndroidDBManager {
  static WanAndroidDBManager _sManager;

  WanAndroidDBManager._();

  factory WanAndroidDBManager.getInstance() {
    if (_sManager == null) {
      _sManager = WanAndroidDBManager._();
    }
    return _sManager;
  }

  Future<Database> openDataBase(String dbName) async {
    var dbDir = await getDatabasesPath();
    var dbPath = "$dbDir/$dbName";
    return openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      await db.execute(UserLoginTable.CREATE_TABLE);
    });
  }
}

abstract class Dao<Model> {
  static Database _database;

  static Future open() async {
    if (_database != null) return;
    _database = await WanAndroidDBManager.getInstance().openDataBase(DB_NAME);
  }

  static Future close() async{
    if (_database == null) return;
    _database.close();
    _database = null;
  }

  Future insert(Model model);

  Future delete(Model model);

  Future query();

  Future update(Model model);

  Future<bool> waitDataBaseInit() async {
    int time = 0;
    while (_database == null && time < 5) {
      time += 1;
      await Future.delayed(Duration(milliseconds: 10));
    }
    if (time >= 5) {
      //超时
      return false;
    }
    return true;
  }
}

class UserLoginDao extends Dao<User> {

  UserLoginDao();

  @override
  Future<int> delete(User model) async {
    await Dao.open();
    var id = model.id;
    return Dao._database
        .delete(UserLoginTable.TABLE_NAME, where: "id=?", whereArgs: [id]);
  }

  @override
  Future<int> insert(User model) async {
    await Dao.open();
    return Dao._database.insert(UserLoginTable.TABLE_NAME, User.toJson(model));
  }

  @override
  Future<List<User>> query() async {
    await Dao.open();
    List<Map<String, dynamic>> result =
        await Dao._database.query(UserLoginTable.TABLE_NAME, limit: 1);
    if(result.length>0){
      List<User> user = result.map<User>((e) => User.fromJson(e)).toList();
      return user;
    }else return null;

  }

  @override
  Future<int> update(User model) async {
    await Dao.open();
    return Dao._database.update(UserLoginTable.TABLE_NAME, User.toJson(model),
        where: "id=?", whereArgs: [model.id]);
  }

}
