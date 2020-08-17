// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_knowlodge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemKnowlodge _$SystemKnowlodgeFromJson(Map<String, dynamic> json) {
  return SystemKnowlodge(
    courseId: json['courseId'] as int,
    id: json['id'] as int,
    name: json['name'] as String,
    order: json['order'] as int,
    parentChapterId: json['parentChapterId'] as int,
    userControlSetTop: json['userControlSetTop'] as bool,
    visible: json['visible'] as int,
    children: _buildChildren(json['children']),
  );

}
List<SystemKnowlodge> _buildChildren(List children){
  List<SystemKnowlodge> knowlodges = [];
  children?.forEach((element) {
    knowlodges.add(_$SystemKnowlodgeFromJson(element));
  });
  return knowlodges;
}
