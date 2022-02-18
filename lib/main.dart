import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid/app.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/page/error_page.dart';

import 'env/env.dart';

void main() {
  runZonedGuarded(() {
    //单例的ErrorWidget，用来显示报错信息，可以把信息上传到服务器
    ErrorWidget.builder = (details) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
      return ErrorPage(
          details.exception.toString() + "\n" + details.stack.toString(),
          details);
    };
    //让系统UI的样式
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    runApp(EnvWrapper(
        env: DevEnv(),
        child: ChangeNotifierProvider(
            create: (context) {
              //初始化Sp中的状态
              return GlobalState();
            },
            builder: (context, child) => child,
            child: FlutterReduxApp())));
  }, (error, stack) {
    // do nothing
    //将stack上传后台或写入
  });
}
