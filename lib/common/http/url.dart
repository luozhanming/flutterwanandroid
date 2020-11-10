/*****************************Wanandroid api*****************************/

class WanandroidUrl {
  //首页Banner GET
  static const String homeBanner = "/banner/json";
  //首页文章 GET
  static String homeArtical(int page) => "/article/list/${page}/json";
  //搜索热词
  static const String searchHots = "/hotkey/json";
  //搜索文章
  static String searchArtical(int page)=>"/article/query/$page/json";
  //体系结构 GET
  static const String systemTree = "https://www.wanandroid.com/tree/json";
  //体系文章 GET
  static String systemArtical(int cid,int page)=>"https://www.wanandroid.com/article/list/$page/json";
  //作者文章
  static String authorArticals(String name,int page)=>"https://wanandroid.com/article/list/$page/json";
  //登录 POST
  static String login = "https://www.wanandroid.com/user/login";
  //注册 POST
  static String register = "https://www.wanandroid.com/user/register";
  //退出登录
  static String logout = "https://www.wanandroid.com/user/logout/json";
  //项目树
  static const String projectTree = "https://www.wanandroid.com/project/tree/json";
  //项目文章
  static String projectArtical(int cid,int page) => "https://www.wanandroid.com/project/list/$page/json?cid=$cid";
  //我的收藏
  static String myCollectionArtical(int page) => "https://www.wanandroid.com/lg/collect/list/$page/json";

}
