import 'package:json_annotation/json_annotation.dart';

class HomeBanner {
  String _desc;
  int _id;
  String _imagePath;
  int _isVisible;
  int _order;
  String _title;
  int _type;
  String _url;

  HomeBanner(
      {String desc,
        int id,
        String imagePath,
        int isVisible,
        int order,
        String title,
        int type,
        String url}) {
    this._desc = desc;
    this._id = id;
    this._imagePath = imagePath;
    this._isVisible = isVisible;
    this._order = order;
    this._title = title;
    this._type = type;
    this._url = url;
  }

  String get desc => _desc;
  set desc(String desc) => _desc = desc;
  int get id => _id;
  set id(int id) => _id = id;
  String get imagePath => _imagePath;
  set imagePath(String imagePath) => _imagePath = imagePath;
  int get isVisible => _isVisible;
  set isVisible(int isVisible) => _isVisible = isVisible;
  int get order => _order;
  set order(int order) => _order = order;
  String get title => _title;
  set title(String title) => _title = title;
  int get type => _type;
  set type(int type) => _type = type;
  String get url => _url;
  set url(String url) => _url = url;

  HomeBanner.fromJson(Map<String, dynamic> json) {
    _desc = json['desc'];
    _id = json['id'];
    _imagePath = json['imagePath'];
    _isVisible = json['isVisible'];
    _order = json['order'];
    _title = json['title'];
    _type = json['type'];
    _url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desc'] = this._desc;
    data['id'] = this._id;
    data['imagePath'] = this._imagePath;
    data['isVisible'] = this._isVisible;
    data['order'] = this._order;
    data['title'] = this._title;
    data['type'] = this._type;
    data['url'] = this._url;
    return data;
  }
}
