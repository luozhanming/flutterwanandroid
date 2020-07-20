

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanandroid/model/global_state.dart';
import '';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
    );
  }


  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Center(),
      flexibleSpace: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Center(
          child: Row(
            children: <Widget>[
              Padding(
                  padding:
                  EdgeInsets.only(left: ScreenUtil().setWidth(8))),
              Builder(
                //将context范围缩到Scaffold
                builder: (context) => InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: OvalWidget(
                      width: ScreenUtil().setWidth(30),
                      height: ScreenUtil().setWidth(30),
                      child: Image.asset(
                        "${Config.PATH_IMAGE}ic_pic.jpg",
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Padding(
                  padding:
                  EdgeInsets.only(left: ScreenUtil().setWidth(8))),
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.black54,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(3))),
                  onTap: () {
                    context
                        .read<GlobalState>()
                        .setTheme(ThemeData(primaryColor: Colors.green));
                  },
                  child: Container(
                    margin:
                    EdgeInsets.only(right: ScreenUtil().setWidth(8)),
                    height: ScreenUtil().setWidth(26),
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(3))),
                        border: Border.all(color: Colors.black12)),
                    child: Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(6)),
                            child: Icon(Icons.search,
                                size: ScreenUtil().setWidth(20),
                                color: context
                                    .select<GlobalState, ThemeData>(
                                        (value) => value.themeData)
                                    .primaryTextTheme
                                    .title
                                    .color),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(4)),
                            child: Text(
                              S.of(context).search_website_content,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(14),
                                  color: context
                                      .select<GlobalState, ThemeData>(
                                          (value) => value.themeData)
                                      .primaryTextTheme
                                      .title
                                      .color),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ), //// AppBar是固定56高度的
    );
  }
}
