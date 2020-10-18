

import 'package:json_annotation/json_annotation.dart';

part 'prochapter.g.dart';

@JsonSerializable(createToJson: false)
class ProChapter{
  final String name;
  final int courseId;
  final int id;
  final int parentChapterId;
  final int order;
  final bool userControlSetTop;
  final int visible;

  ProChapter({this.name, this.courseId, this.id, this.parentChapterId,
      this.order, this.userControlSetTop, this.visible});

  factory ProChapter.fromJson(Map<String,dynamic> json) => _$ProChapterFromJson(json);


}