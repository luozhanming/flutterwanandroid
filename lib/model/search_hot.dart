import 'package:json_annotation/json_annotation.dart';

class SearchHot {
  int _id;
  String _link;
  String _name;
  int _order;
  int _visible;

  SearchHot({int id, String link, String name, int order, int visible}) {
    this._id = id;
    this._link = link;
    this._name = name;
    this._order = order;
    this._visible = visible;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get link => _link;
  set link(String link) => _link = link;
  String get name => _name;
  set name(String name) => _name = name;
  int get order => _order;
  set order(int order) => _order = order;
  int get visible => _visible;
  set visible(int visible) => _visible = visible;

  SearchHot.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _link = json['link'];
    _name = json['name'];
    _order = json['order'];
    _visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['link'] = this._link;
    data['name'] = this._name;
    data['order'] = this._order;
    data['visible'] = this._visible;
    return data;
  }
}
