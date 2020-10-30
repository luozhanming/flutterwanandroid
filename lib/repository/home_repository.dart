import 'dart:async';

import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/http/http_manager.dart';
import 'package:wanandroid/common/http/url.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/banner.dart';
import 'package:wanandroid/model/pager.dart';
import 'package:wanandroid/model/search_hot.dart';

abstract class IHomeRepository {
  Stream<List<HomeBanner>> refreshBanner();

  Stream<Pager<Artical>> loadHomeArticals(int page);

  Stream<Pager<Artical>> searchArtical(String key, int page);

  Stream<List<SearchHot>> loadSearchHot();
}

class RemoteHomeRepository extends IHomeRepository {
  HttpManager _httpManager;

  RemoteHomeRepository() {
    _httpManager = HttpManager.getManager(Config.ENV.baseUrl);
  }

  ///
  ///加载首页Banner
  ///
  Stream<List<HomeBanner>> refreshBanner() async* {
    yield* _httpManager.get(WanandroidUrl.homeBanner).map((event) {
      List<dynamic> rawList = event.dataList;
      List<HomeBanner> banners = [];
      rawList.forEach((element) {
        if (element is Map<String, dynamic>) {
          HomeBanner banner = HomeBanner.fromJson(element);
          banners.add(banner);
        }
      });
      return banners;
    });
  }

  ///
  /// 加载首页文章
  ///
  Stream<Pager<Artical>> loadHomeArticals(int page) async* {
    yield* _httpManager.get(WanandroidUrl.homeArtical(page)).map((event) {
      Pager<dynamic> pager = Pager.fromJson(event.dataJson);
      List<dynamic> datasList = pager.datas;
      List<Artical> articals = [];
      datasList.forEach((element) {
        if (element is Map<String, dynamic>) {
          articals.add(Artical.fromJson(element));
        }
      });
      var result = Pager<Artical>.copyWith(pager, articals);
      return result;
    });
  }

  ///
  /// 搜索文章
  ///
  Stream<Pager<Artical>> searchArtical(String key, int page) async* {
    var data = {"k": key};
    yield* _httpManager
        .post(WanandroidUrl.searchArtical(page), data)
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
      return result;
    });
  }

  ///
  /// 搜索热词
  ///
  Stream<List<SearchHot>> loadSearchHot() async* {
    yield* _httpManager.get(WanandroidUrl.searchHots).map((event) {
      var list = event.dataList;
      List<SearchHot> searchHots = [];
      list.forEach((element) {
        if (element is Map<String, dynamic>) {
          searchHots.add(SearchHot.fromJson(element));
        }
      });
      return searchHots;
    });
  }
}
