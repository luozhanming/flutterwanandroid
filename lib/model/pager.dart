import 'package:json_annotation/json_annotation.dart';

part 'pager.g.dart';

@JsonSerializable(createToJson: false)
class Pager<T> {
  final List<T> datas;
   int curPage;
  final int offset;
   bool over;
  final int pageCount;
  final int size;
  final int total;

   Pager(
      {this.datas,
      this.curPage,
      this.offset,
      this.over,
      this.pageCount,
      this.size,
      this.total});

  factory Pager.fromJson(Map<String,dynamic> json) =>_$PagerFromJson(json);

  factory  Pager.copyWith(Pager page,List<T> datas){
    return Pager(curPage: page.curPage,offset: page.offset,over: page.over,
    pageCount: page.pageCount,size: page.size,total: page.total,
    datas: datas);
  }

  bool isLoadMore(){
    return curPage>1;
  }
}

