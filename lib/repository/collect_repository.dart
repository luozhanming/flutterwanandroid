import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/http/http_manager.dart';
import 'package:wanandroid/common/http/url.dart';
import 'package:wanandroid/model/artical.dart';

abstract class ICollectionsRepository {
  Stream<List<Artical>> loadMyCollections(int page);
}


class RemoteCollectionsRepository extends ICollectionsRepository {

  HttpManager _httpManager;

  RemoteCollectionsRepository() {
    _httpManager = HttpManager.getManager(Config.ENV.baseUrl);
  }


  @override
  Stream<List<Artical>> loadMyCollections(int page) async* {
    yield* _httpManager.get(WanandroidUrl.myCollectionArtical(page))
        .map((event) {
      List<dynamic> rawList = event.dataList;
      List<Artical> articals = [];
      rawList.forEach((element) {
        if (element is Map<String, dynamic>) {
          Artical artical = Artical.fromJson(element);
          articals.add(artical);
        }
      });
      return articals;
    });
  }

}