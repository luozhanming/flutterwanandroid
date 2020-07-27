import 'package:json_annotation/json_annotation.dart';

part 'search_hot.g.dart';

@JsonSerializable(createToJson: false)
class SearchHot {
  final int id;
  final String link;
  final String name;
  final int order;
  final int visible;

  const SearchHot({this.id, this.link, this.name, this.order, this.visible});

  factory SearchHot.fromJson(Map<String,dynamic> json)=>_$SearchHotFromJson(json);
}
