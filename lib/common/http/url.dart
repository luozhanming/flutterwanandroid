/*****************************Wanandroid api*****************************/
////首页banner
//static const String HOME_BANNER = "/banner/json";
//
////首页文章
//static const String HOME_ARTICAL =
//    "https://www.wanandroid.com/article/list/0/json";
//
////搜索热词
//static const String SEARCH_HOT = "/hotkey/json";

class WanandroidUrl {
  static const String homeBanner = "/banner/json";

  static String homeArtical(int page) => "/article/list/${page}/json";

  //搜索热词
  static const String searchHots = "/hotkey/json";

  //搜索文章
  static String searchArtical(int page)=>"/article/query/$page/json";

  static const String systemTree = "https://www.wanandroid.com/tree/json";

  static String systemArtical(int cid,int page)=>"https://www.wanandroid.com/article/list/$page/json";
}
