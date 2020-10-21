

import 'package:json_annotation/json_annotation.dart';


class ProChapter {
  int _courseId;
  int _id;
  String _name;
  int _order;
  int _parentChapterId;
  bool _userControlSetTop;
  int _visible;

  ProChapter(
      {int courseId,
        int id,
        String name,
        int order,
        int parentChapterId,
        bool userControlSetTop,
        int visible}) {
    this._courseId = courseId;
    this._id = id;
    this._name = name;
    this._order = order;
    this._parentChapterId = parentChapterId;
    this._userControlSetTop = userControlSetTop;
    this._visible = visible;
  }

  int get courseId => _courseId;
  set courseId(int courseId) => _courseId = courseId;
  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  int get order => _order;
  set order(int order) => _order = order;
  int get parentChapterId => _parentChapterId;
  set parentChapterId(int parentChapterId) =>
      _parentChapterId = parentChapterId;
  bool get userControlSetTop => _userControlSetTop;
  set userControlSetTop(bool userControlSetTop) =>
      _userControlSetTop = userControlSetTop;
  int get visible => _visible;
  set visible(int visible) => _visible = visible;

  ProChapter.fromJson(Map<String, dynamic> json) {
    _courseId = json['courseId'];
    _id = json['id'];
    _name = json['name'];
    _order = json['order'];
    _parentChapterId = json['parentChapterId'];
    _userControlSetTop = json['userControlSetTop'];
    _visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseId'] = this._courseId;
    data['id'] = this._id;
    data['name'] = this._name;
    data['order'] = this._order;
    data['parentChapterId'] = this._parentChapterId;
    data['userControlSetTop'] = this._userControlSetTop;
    data['visible'] = this._visible;
    return data;
  }
}
