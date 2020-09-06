
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(createToJson: true)
class User{

  final bool admin;

  final String email;

  final String icon;

  final int id;

  final String nickname;

  final String publicName;

  final String token;

  final int type;

  final String username;

  const User({this.admin, this.email, this.icon, this.id, this.nickname,
      this.publicName, this.token, this.type, this.username});


  factory User.fromJson(Map<String,dynamic> json)=>_$UserFromJson(json);


  static Map<String,dynamic> toJson(User user)=>{
    "admin":user.admin,
    "email":user.email,
    "icon":user.icon,
    "id":user.id,
    "nickname":user.nickname,
    "publicNmae":user.publicName,
    "token":user.token,
    "type":user.type,
    "username":user.username
  };


}