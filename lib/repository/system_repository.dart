import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/http/http_manager.dart';
import 'package:wanandroid/common/http/url.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/pager.dart';
import 'package:wanandroid/model/resource.dart';
import 'package:wanandroid/model/system_knowlodge.dart';

class SystemRepository {

  HttpManager _httpManager;

  SystemRepository() {
    _httpManager = HttpManager.getManager(Config.ENV.baseUrl);
  }

  /// 加载专题树结
  Stream<Resource<List<SystemKnowlodge>>> loadSystemTree() async* {
    yield* _httpManager.get(WanandroidUrl.systemTree)
        .map((event) {
      List<SystemKnowlodge> knowlodges = [];
      if (event.dataList.isNotEmpty) {
        event.dataList.forEach((element) {
          var knowlodge = SystemKnowlodge.fromJson(element);
          if(knowlodge.children.isNotEmpty){
            knowlodges.add(knowlodge);
          }
        });
      }
      return Resource.success(knowlodges);
    });
  }

  /// 加载专题树下专题文章
  Stream<Resource<Pager<Artical>>> loadSystemArtical(int page,int cid) async*{
    yield* _httpManager.get(WanandroidUrl.systemArtical(cid, page),{"cid":cid}).map((event) {
      Pager<dynamic> pager = Pager.fromJson(event.dataJson);
      List<dynamic> datasList = pager.datas;
      List<Artical> articals = [];
      datasList?.forEach((element) {
        if (element is Map<String, dynamic>) {
          articals.add(Artical.fromJson(element));
        }
      });
      var result = Pager<Artical>.copyWith(pager, articals);
      return Resource.success(result);
    });
  }

  /// 加载作者文章
  Stream<Resource<Pager<Artical>>> loadAuthorArticals(String name,int page) async*{
    yield* _httpManager.get(WanandroidUrl.authorArticals(name, page)).map((event) {
      Pager<dynamic> pager = Pager.fromJson(event.dataJson);
      List<dynamic> datasList = pager.datas;
      List<Artical> articals = [];
      datasList?.forEach((element) {
        if (element is Map<String, dynamic>) {
          articals.add(Artical.fromJson(element));
        }
      });
      var result = Pager<Artical>.copyWith(pager, articals);
      return Resource.success(result);
    });
  }



}