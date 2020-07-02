import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/widget/circle_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: Config.DESIGN_WIDTH);
    return Scaffold(
        appBar: AppBar(
          leading: UnconstrainedBox(  //解除限制
              child: OvalWidget(width: ScreenUtil().setWidth(24),
                height: ScreenUtil().setWidth(24),
                child:Image.network("https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3002726819,68308266&fm=26&gp=0.jpg",fit: BoxFit.cover,))),
          title: UnconstrainedBox(
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(3))),
              onTap: (){

              },
              child: Container(
                width: ScreenUtil().setWidth(305),
                height: ScreenUtil().setWidth(20),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(3))),
                  border: Border.all(color: Colors.black12)
                ),
                child: Row(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                        child: Icon(Icons.search),
                      ),
                    ),Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setWidth(2)),
                        child: Text(S.of(context).search_website_content),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
