import 'package:json_annotation/json_annotation.dart';

part 'banner.g.dart';

@JsonSerializable(createToJson: false)
class HomeBanner {
  String desc;
  int id;
  String imagePath;
  int isVisible;
  int order;
  String title;
  int type;
  String url;

  HomeBanner(
      {this.desc,
      this.id,
      this.imagePath,
      this.isVisible,
      this.order,
      this.title,
      this.type,
      this.url});

  factory HomeBanner.formJson(Map<String, dynamic> json) =>
      _$HomeBannerFromJson(json);
}
