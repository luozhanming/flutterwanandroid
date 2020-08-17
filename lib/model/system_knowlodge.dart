import 'package:json_annotation/json_annotation.dart';

part 'system_knowlodge.g.dart';

@JsonSerializable(createToJson: false)
class SystemKnowlodge {
  final int courseId;
  final int id;
  final String name;
  final int order;
  final int parentChapterId;
  final bool userControlSetTop;
  final int visible;
  final List<dynamic> children;

  const SystemKnowlodge({this.courseId, this.id, this.name, this.order,
      this.parentChapterId, this.userControlSetTop, this.visible,
      this.children});

  factory SystemKnowlodge.fromJson(Map<String,dynamic> json) =>_$SystemKnowlodgeFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SystemKnowlodge &&
              runtimeType == other.runtimeType &&
              courseId == other.courseId &&
              id == other.id &&
              parentChapterId == other.parentChapterId;

  @override
  int get hashCode =>
      courseId.hashCode ^
      id.hashCode ^
      parentChapterId.hashCode;

}
