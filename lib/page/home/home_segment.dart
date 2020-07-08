import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/widget/banner.dart';

class HomeSegment extends StatefulWidget {
  @override
  _HomeSegmentState createState() => _HomeSegmentState();
}

class _HomeSegmentState extends State<HomeSegment> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(8),left:ScreenUtil().setWidth(16),right: ScreenUtil().setWidth(16)),
              height: ScreenUtil().setWidth(200),
              child: BannerView(items: [
                BannerItem(NetworkImage("https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1644792247,4040788430&fm=26&gp=0.jpg"),message: "sdfsdfsdf"),
                BannerItem(NetworkImage("https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1644792247,4040788430&fm=26&gp=0.jpg"))
              ],
              ))
        ],
      ),
    );
  }
}

class HomeSegmentViewModel extends BaseViewModel {
  @override
  void initState() {}
}
