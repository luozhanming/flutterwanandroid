import 'package:fluro/fluro.dart';
import 'route_handler.dart';

class Routes {
  static Routes _instance;

  /********************添加页面路由名称***********************/
  static const String ROOT = "/"; //根页面

  Router _router;

  Routes._() {
    _router = Router();
  }

  static Routes getInstance() {
    if (_instance == null) {
      _instance = Routes._();
    }
    return _instance;
  }

  void configureRoutes(Router router) {
    router.define(ROOT, handler: homeHandler,transitionType: TransitionType.material);
  }

  Router getRouter() => _router;
}
