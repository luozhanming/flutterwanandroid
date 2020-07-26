import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanandroid/common/config/config.dart';

//TODO 方法定义为类型的办法
typedef OnLeadingIconTap = void Function();

class MyAppBar extends PreferredSize{

 final IconData leadingIcon;
 final Widget widget;
 final OnLeadingIconTap onLeadingIconTap;

 @override
  Size get preferredSize => Size(ScreenUtil().setWidth(Config.DESIGN_WIDTH),
     ScreenUtil().setWidth(40));


 const MyAppBar({this.leadingIcon=Icons.arrow_back, this.widget,this.onLeadingIconTap});

 @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize:preferredSize,
        child: AppBar(
          leading: Center(),
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Center(
              child: Row(
                children: <Widget>[
                  Builder(
                      //将context范围缩到Scaffold
                      builder: (context) => Container(
                        alignment: Alignment.center,
                        width: ScreenUtil().setWidth(40),
                        height: ScreenUtil().setWidth(40),
                        child: InkWell(
                          child: Center(
                            child: Icon(
                              leadingIcon,
                              color: Colors.white,
                              size: ScreenUtil().setWidth(24),
                            ),
                          ),
                          onTap: () {
                            onLeadingIconTap?.call();
                          },
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(8))),
                  Expanded(
                    child: widget,
                  )
                ],
              ),
            ),
          ), //// AppBar是固定56高度的
        ));
  }
}
