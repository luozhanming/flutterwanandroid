import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanandroid/app.dart';
import 'package:wanandroid/page/error_page.dart';

import 'env/env.dart';

void main() {
  runZonedGuarded(() {
    ErrorWidget.builder = (details) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
      return ErrorPage(
          details.exception.toString() + "\n" + details.stack.toString(),
          details);
    };
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    runApp(EnvWrapper(env: DevEnv(), child: FlutterReduxApp()));
  }, (error, stack) {
    // do nothing
    //将stack上传后台或写入
  });
}
