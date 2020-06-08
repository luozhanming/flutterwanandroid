import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanandroid/app.dart';
import 'package:wanandroid/page/error_page.dart';
import 'common/router/routes_util.dart';


void main() {
  runZonedGuarded(() {
    ErrorWidget.builder = (details) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
      return ErrorPage(
          details.exception.toString() + "\n" + details.stack.toString(),
          details
      );
    };
    runApp(FlutterReduxApp());
  }, (error, stack) {
    // do nothing
    //将stack上传后台或写入
  });
}


