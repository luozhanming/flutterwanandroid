
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable(createToJson: true)
class User{
  const User({this.name});

  final String name;



}