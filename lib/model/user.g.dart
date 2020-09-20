// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {

  return User(
    admin: json['admin'].runtimeType==bool?json['admin'] as bool:json['admin'] as int ,
    email: json['email'] as String,
    icon: json['icon'] as String,
    id: json['id'] as int,
    nickname: json['nickname'] as String,
    publicName: json['publicName'] as String,
    token: json['token'] as String,
    type: json['type'] as int,
    username: json['username'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'admin': instance.admin,
      'email': instance.email,
      'icon': instance.icon,
      'id': instance.id,
      'nickname': instance.nickname,
      'publicName': instance.publicName,
      'token': instance.token,
      'type': instance.type,
      'username': instance.username,
    };
