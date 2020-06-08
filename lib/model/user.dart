
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(createToJson: false)
class User{
  const User({this.name});

  final String name;
}