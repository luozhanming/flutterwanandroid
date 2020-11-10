
import 'package:json_annotation/json_annotation.dart';

class User {
  int _admin;
  String _email;
  String _icon;
  int _id;
  String _nickname;
  String _publicName;
  String _token;
  int _type;
  String _username;

  User(
      {int admin,
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
    this._email = email;
    this._icon = icon;
    this._id = id;
    this._nickname = nickname;
    this._publicName = publicName;
    this._token = token;
    this._type = type;
    this._username = username;
  }

  int get admin => _admin;
  set admin(int admin) => _admin = admin;

  String get email => _email;
  set email(String email) => _email = email;
  String get icon => _icon;
  set icon(String icon) => _icon = icon;
  int get id => _id;
  set id(int id) => _id = id;
  String get nickname => _nickname;
  set nickname(String nickname) => _nickname = nickname;

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
    _email = json['email'];
    _icon = json['icon'];
    _id = json['id'];
    _nickname = json['nickname'];
    _publicName = json['publicName'];
    _token = json['token'];
    _type = json['type'];
    _username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admin'] = this._admin;
    data['email'] = this._email;
    data['icon'] = this._icon;
    data['id'] = this._id;
    data['nickname'] = this._nickname;
    data['publicName'] = this._publicName;
    data['token'] = this._token;
    data['type'] = this._type;
    data['username'] = this._username;
    return data;
  }
}
