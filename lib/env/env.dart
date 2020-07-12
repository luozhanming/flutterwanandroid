import 'package:flutter/widgets.dart';

/**
 * 环境配置
 * */
mixin Env {
  String get envName;

  String get baseUrl;
}

/**
 * 开发环境配置
 * */
class DevEnv with Env {
  @override
  String get baseUrl => "https://www.wanandroid.com/";

  @override
  String get envName => "Dev";
}

/**
 * 测试环境配置
 * */
class BetaEnv with Env {
  @override
  String get baseUrl => throw UnimplementedError();

  @override
  String get envName => "Beta";
}

/**
 *生产环境配置
 * */
class PDEnv with Env {
  @override
  String get baseUrl => throw UnimplementedError();

  @override
  String get envName => "Product";
}

class EnvWrapper extends StatelessWidget {
  final Widget child;
  final Env env;

  EnvWrapper({@required this.env, @required this.child}) : assert(env != null);

  @override
  Widget build(BuildContext context) {
    return _EnvInheritedWidget(this.env, child);
  }

  static Env of(BuildContext context) {
    var widget =
        context.dependOnInheritedWidgetOfExactType<_EnvInheritedWidget>();
    return widget._env;
  }
}

class _EnvInheritedWidget extends InheritedWidget {
  _EnvInheritedWidget(this._env, Widget child) : super(child: child);

  final Env _env;

  @override
  bool updateShouldNotify(_EnvInheritedWidget oldWidget) {
    return _env != oldWidget._env;
  }
}
