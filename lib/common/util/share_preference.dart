import 'package:shared_preferences/shared_preferences.dart';

class CommonPreference {
  static const SP_NAME = "Common";

  static const KEY_TOKEN = "login_token";

  static const KEY_USERNAME = "login_username";

  static const KEY_PASSWORD = "login_password";

  static const KEY_AUTO_LOGIN = "login_auto";

  static const KEY_LOGIN_USER = "login_user";



  static CommonPreference _preference;

  CommonPreference() {

  }

  factory CommonPreference.getPreference() {
    if (_preference == null) {
      _preference = CommonPreference();
    }
    return _preference;
  }

  Future<T> get<T>(String key, T defValue) async{
    SharedPreferences _sp = await SharedPreferences.getInstance();
    dynamic res = null;
    switch (defValue.runtimeType) {
      case int:
        res = _sp.getInt(key);
        break;
      case bool:
        res = _sp.getBool(key);
        break;
      case double:
        res = _sp.getDouble(key);
        break;
      case String:
        res = _sp.getString(key);
        break;
      case List:
        res = _sp.getStringList(key);
        break;
      default:
        throw new Exception("No support this type.");
        break;
    }
    if (res == null) res = defValue;
    return res as T;
  }

  void put(String key, dynamic value) async{
    SharedPreferences _sp = await SharedPreferences.getInstance();
    switch (value.runtimeType) {
      case int:
        _sp.setInt(key, value as int);
        break;
      case bool:
        _sp.setBool(key, value as bool);
        break;
      case double:
        _sp.setDouble(key, value as double);
        break;
      case String:
        _sp.setString(key, value as String);
        break;
      case List:
        var list = value as List;
        var first = list.first;
        if (first != null && first is String) {
          _sp.setStringList(key, value as List<String>);
        } else {
          throw new Exception("No support this type.");
        }
        break;
      default:
        throw new Exception("No support this type.");
        break;
    }
  }
}
