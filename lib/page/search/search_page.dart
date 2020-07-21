import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/widget/circle_widget.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  static const String NAME = "Search";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>  with RouteAware{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(ScreenUtil().setWidth(Config.DESIGN_WIDTH),
              ScreenUtil().setWidth(40)),
          child: _buildAppBar(context)),
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
              Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(8))),
              Builder(
                //将context范围缩到Scaffold
                builder: (context) => Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(40),
                  height: ScreenUtil().setWidth(40),
                  child: IconButton (
                    padding: EdgeInsets.all(0),
                    constraints:BoxConstraints(
                      maxWidth: ScreenUtil().setWidth(40),
                      maxHeight: ScreenUtil().setWidth(40)
                    ),
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(8))),
              Expanded(
                child: _buildSearchField(context),
              )
            ],
          ),
        ),
      ), //// AppBar是固定56高度的
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: TextField(

        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: S.of(context).search_website_content,
            focusColor: Colors.lightBlueAccent),
      ),
    );
  }
}
