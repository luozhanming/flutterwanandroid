
import 'package:json_annotation/json_annotation.dart';

class User {
  bool _admin;
  int _coinCount;
  List<int> _collectIds;
  String _email;
  String _icon;
  int _id;
  String _nickname;
  String _password;
  String _publicName;
  String _token;
  int _type;
  String _username;

  User(
      {bool admin,
        int coinCount,
        List<int> collectIds,
        String email,
        String icon,
        int id,
        String nickname,
        String password,
        String publicName,
        String token,
        int type,
        String username}) {
    this._admin = admin;
    this._coinCount = coinCount;
    this._collectIds = collectIds;
    this._email = email;
    this._icon = icon;
    this._id = id;
    this._nickname = nickname;
    this._password = password;
    this._publicName = publicName;
    this._token = token;
    this._type = type;
    this._username = username;
  }

  bool get admin => _admin;
  set admin(bool admin) => _admin = admin;
  int get coinCount => _coinCount;
  set coinCount(int coinCount) => _coinCount = coinCount;
  List<int> get collectIds => _collectIds;
  set collectIds(List<int> collectIds) => _collectIds = collectIds;
  String get email => _email;
  set email(String email) => _email = email;
  String get icon => _icon;
  set icon(String icon) => _icon = icon;
  int get id => _id;
  set id(int id) => _id = id;
  String get nickname => _nickname;
  set nickname(String nickname) => _nickname = nickname;
  String get password => _password;
  set password(String password) => _password = password;
  String get publicName => _publicName;
  set publicName(String publicName) => _publicName = publicName;
  String get token => _token;
  set token(String token) => _token = token;
  int get type => _type;
  set type(int type) => _type = type;
  String get username => _username;
  set username(String username) => _username = username;

  User.fromJson(Map<String, dynamic> json) {
    _admin = json['admin'];
    _coinCount = json['coinCount'];
    _collectIds = json['collectIds'].cast<int>();
    _email = json['email'];
    _icon = json['icon'];
    _id = json['id'];
    _nickname = json['nickname'];
    _password = json['password'];
    _publicName = json['publicName'];
    _token = json['token'];
    _type = json['type'];
    _username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admin'] = this._admin;
    data['coinCount'] = this._coinCount;
    data['collectIds'] = this._collectIds;
    data['email'] = this._email;
    data['icon'] = this._icon;
    data['id'] = this._id;
    data['nickname'] = this._nickname;
    data['password'] = this._password;
    data['publicName'] = this._publicName;
    data['token'] = this._token;
    data['type'] = this._type;
    data['username'] = this._username;
    return data;
  }
}
