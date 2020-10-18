import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/http/http_manager.dart';
import 'package:wanandroid/common/http/url.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/pager.dart';
import 'package:wanandroid/model/prochapter.dart';
import 'package:wanandroid/model/resource.dart';

abstract class IProjectRepository {
  Stream<Resource<List<ProChapter>>> loadProjectTree();

  Stream<Resource<Pager<Artical>>> loadProject(int cid, int page);
}

class LocalProjectRepository extends IProjectRepository {
  @override
  Stream<Resource<Pager<Artical>>>  loadProject(int cid, int page) {
    throw UnimplementedError();
  }

  @override
  Stream<Resource<List<ProChapter>>> loadProjectTree() {
    throw UnimplementedError();
  }
}

class RemoteProjectRepository extends IProjectRepository {
  HttpManager _httpManager;

  RemoteProjectRepository() {
    _httpManager = HttpManager.getManager(Config.ENV.baseUrl);
  }

  @override
  Stream<Resource<Pager<Artical>>> loadProject(int cid, int page) {
    return _httpManager
        .get(WanandroidUrl.projectArtical(cid, page))
        .map((event) {
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
  Stream<Resource<List<ProChapter>>> loadProjectTree() {
    return _httpManager.get(WanandroidUrl.projectTree)
        .map((event) {
      List<ProChapter> articals = [];
      var list = event.dataList.map((e) => ProChapter.fromJson(e)).toList();
      return Resource.success(list);
    });
  }
}
