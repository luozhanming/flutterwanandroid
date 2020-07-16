// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pager _$PagerFromJson(Map<String, dynamic> json) {
  return Pager(
    datas: json['datas'] as List,
    curPage: json['curPage'] as int,
    offset: json['offset'] as int,
    over: json['over'] as bool,
    pageCount: json['pageCount'] as int,
    size: json['size'] as int,
    total: json['total'] as int,
  );
}
