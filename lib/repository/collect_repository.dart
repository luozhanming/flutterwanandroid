import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/http/http_manager.dart';
import 'package:wanandroid/common/http/url.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/pager.dart';
import 'package:wanandroid/model/resource.dart';

abstract class ICollectionsRepository {
  Stream<Resource<Pager<Artical>>> loadMyCollections(int page);

  Stream<bool> collectArtical(Artical artical);

  Stream<bool> uncollectArtical(Artical artical);
}

class RemoteCollectionsRepository extends ICollectionsRepository {
  HttpManager _httpManager;

  RemoteCollectionsRepository() {
    _httpManager = HttpManager.getManager(Config.ENV.baseUrl);
  }

  @override
  Stream<Resource<Pager<Artical>>> loadMyCollections(int page) async* {
    yield* _httpManager
        .get(WanandroidUrl.myCollectionArtical(page))
        .map((event){
      Pager<dynamic> pager = Pager.fromJson(event.dataJson);
      List<dynamic> datasList = pager.datas;
      List<Artical> articals = [];
      datasList.forEach((element) {
        if (element is Map<String, dynamic>) {
          articals.add(Artical.fromJson(element));
        }
      });
      var result = Pager<Artical>.copyWith(pager, articals);
      return Resource.success(result);
    });
  }


  @override
  Stream<bool> collectArtical(Artical artical) async* {
    yield* _httpManager
        .post(WanandroidUrl.collectArtical(artical.id))
        .map((event) {
      return event.errorCode == 0;
    });
  }

  @override
  Stream<bool> uncollectArtical(Artical artical) async* {
    yield* _httpManager
        .post(WanandroidUrl.uncollectArtical(artical.id))
        .map((event) {
      return event.errorCode == 0;
    });
  }


}

