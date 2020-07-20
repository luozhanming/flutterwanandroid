import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid/app.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/page/error_page.dart';
import 'package:wanandroid/widget/artical_item_widget.dart';

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
    runApp(EnvWrapper(env: DevEnv(),
        child: ChangeNotifierProvider(
            create: (context)=>GlobalState(),
            child: MaterialApp(
              builder: (context,child){
                return Scaffold(
                  backgroundColor: Colors.grey,
                  body: _testWidget(context),
                );
              },
            )
        )
    )
    );
  }, (error, stack) {
    // do nothing
    //将stack上传后台或写入
  });
}

Widget _testWidget(BuildContext context) {
 ScreenUtil.init(context,width: 360);
  return FutureBuilder<String>(
    future: loadAssetString("static/file/artical.json"),
    builder:(context,value) {
      if(value.hasData){
        Artical artical = Artical.fromJson(jsonDecode(value.data));
        return ArticalItemWidget(artical);
      }
    }
  );
}

Future<String> loadAssetString(String file) async {
  return await rootBundle.loadString(file);
}
