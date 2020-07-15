
import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable(createToJson: false)
class Tag{
  final String name;
  final String url;

  const Tag({this.name, this.url});
  factory Tag.fromJson(Map<String,dynamic> json) =>_$TagFromJson(json);

}