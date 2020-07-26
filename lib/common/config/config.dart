import 'package:wanandroid/env/env.dart';

/**
 * 配置类，用于app配置，存放常量
 **/
class Config {
  static const bool DEBUG = true;

  /// ////////////////////////////////////常量/////////////////// //

  //设计稿基准宽度
  static const int DESIGN_WIDTH = 360;

  static const String PATH_IMAGE = "static/images/";

  static const int PAGE_SIZE = 20;

  static Env ENV = DevEnv();


  /*****************************Wanandroid api*****************************/
  //首页banner
  static const String HOME_BANNER = "/banner/json";

  //首页文章
  static const String HOME_ARTICAL =
      "https://www.wanandroid.com/article/list/0/json";


  //搜索热词
  static const String SEARCH_HOT = "/hotkey/json";
}
