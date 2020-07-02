// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    username: json['username'] as String,
    admin: json['admin'] as bool,
    email: json['email'] as String,
    icon: json['icon'] as String,
    id: json['id'] as int,
    nickname: json['nickname'] as String,
    password: json['password'] as String,
    publicName: json['publicName'] as String,
    token: json['token'] as String,
    type: json['type'] as int,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'admin': instance.admin,
      'email': instance.email,
      'icon': instance.icon,
      'id': instance.id,
      'nickname': instance.nickname,
      'password': instance.password,
      'publicName': instance.publicName,
      'token': instance.token,
      'type': instance.type,
    };
