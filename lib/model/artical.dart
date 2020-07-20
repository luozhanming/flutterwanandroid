

import 'package:json_annotation/json_annotation.dart';
import 'package:wanandroid/model/tag.dart';

part 'artical.g.dart';

class Artical{
  final String apkLink;
  final int audit;
  final String author;
  final bool canEdit;
  final int chapterId;
  final String chapterName;
  final bool collect;
  final int courseId;
  final String desc;
  final String descMd;
  final String envelopePic;
  final bool fresh;
  final int id;
  final String link;
  final String niceDate;
  final String niceShareDate;
  final String origin;
  final String prefix;
  final String projectLink;
  final int publishTime;
  final int realSuperChapterId;
  final int selfVisible;
  final int shareDate;
  final String shareUser;
  final int superChapterId;
  final String superChapterName;
  final String title;
  final int type;
  final int userId;
  final int visible;
  final int zan;
  List<Tag> tags;

   Artical({this.apkLink, this.audit, this.author="", this.canEdit, this.chapterId,
      this.chapterName, this.collect, this.courseId, this.desc, this.descMd,
      this.envelopePic, this.fresh, this.id, this.link, this.niceDate,
      this.niceShareDate, this.origin, this.prefix, this.projectLink,
      this.publishTime, this.realSuperChapterId, this.selfVisible,
      this.shareDate, this.shareUser="", this.superChapterId,
      this.superChapterName, this.title, this.type, this.userId, this.visible,
      this.zan,this.tags});

factory Artical.fromJson(Map<String,dynamic> json) =>_$ArticalFromJson(json);

}