


import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/http/HttpManager.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/banner.dart';

class HomeModel{
  HttpManager _httpManager;
  
  HomeModel(){
    _httpManager = HttpManager.getManager(Config.ENV.baseUrl);
  }

  /**
   * 加载首页Banner
   * */
  Stream<List<HomeBanner>> refreshBanner() async*{
   yield* _httpManager.get(Config.HOME_BANNER)
        .map((event){
          List<dynamic> rawList = event.dataList;
          List<HomeBanner> banners = [];
          rawList.forEach((element) {
            if(element is Map<String,dynamic>){
              HomeBanner banner = HomeBanner.formJson(element);
              banners.add(banner);
            }
          });
          return banners;
    });
  }

  /**
   * 加载首页文章
   * */
  Stream<List<Artical>> loadHomeArticals(int page) async*{
    yield* _httpManager.get("/article/list/$page/json")
        .map((event){
        Map<String,dynamic> dataMap = event.dataJson;
        List<dynamic> datasList = dataMap["datas"];
        List<Artical> articals = [];
        datasList.forEach((element) {
          if(element is Map<String,dynamic>){
            articals.add(Artical.fromJson(element));
          }
        });
        return articals;
    });
  }

}