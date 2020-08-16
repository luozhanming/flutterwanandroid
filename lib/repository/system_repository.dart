import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/http/http_manager.dart';
import 'package:wanandroid/common/http/url.dart';
import 'package:wanandroid/model/resource.dart';
import 'package:wanandroid/model/system_knowlodge.dart';

class SystemRepository {

  HttpManager _httpManager;

  SystemRepository() {
    _httpManager = HttpManager.getManager(Config.ENV.baseUrl);
  }

  Stream<Resource<List<SystemKnowlodge>>> loadSystemTree() async* {
    yield* _httpManager.get(WanandroidUrl.systemTree)
        .map((event) {
      List<SystemKnowlodge> knowlodges = [];
      if (event.dataList?.isNotEmpty) {
        event.dataList.forEach((element) {
          var knowlodge = SystemKnowlodge.fromJson(element);
          knowlodges.add(knowlodge);
        });
      }
      return Resource.success(knowlodges);
    });
  }
}