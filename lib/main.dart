import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid/app.dart';
import 'package:wanandroid/common/util/share_preference.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/page/error_page.dart';

import 'env/env.dart';
import 'model/user.dart';

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
    runApp(EnvWrapper(env: DevEnv(), 
        child: ChangeNotifierProvider(
          create: (context){
            //初始化Sp中的状态
            return GlobalState();
          },
            builder: (context,child)=>child,
            child: FlutterReduxApp()
        )
    )
    );
  }, (error, stack) {
    // do nothing
    //将stack上传后台或写入
  });
}
