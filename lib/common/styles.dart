import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/**
 * 字体样式
 * */
class TextStyles {
  static TextStyle titleTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(14),
    color: Colors.white,
  );

  static TextStyle h1TextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(12),
    color: Colors.black54,
  );
}
