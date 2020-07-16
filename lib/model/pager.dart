import 'package:json_annotation/json_annotation.dart';

part 'pager.g.dart';

@JsonSerializable(createToJson: false)
class Pager {
  final List<dynamic> datas;
  final int page;
  final int offset;
  final bool over;
  final int pageCount;
  final int pageSize;
  final int total;

  const Pager(
      {this.datas,
      this.page,
      this.offset,
      this.over,
      this.pageCount,
      this.pageSize,
      this.total});

  factory Pager.fromJson(Map<String,dynamic> json) =>_$PagerFromJson(json);
}

