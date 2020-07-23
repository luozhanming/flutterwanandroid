import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wanandroid/common/my_icons.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/tag.dart';

/**
 * 文章item Widget
 * */

class ArticalItemWidget extends StatelessWidget {
  final Artical artical;
  final OnCollectTap onCollectTap;
  final OnArticalTap onArticalTap;
  final bool isLogin;

  ArticalItemWidget(this.artical,
      {this.onArticalTap, this.onCollectTap, this.isLogin})
      : super(key: ObjectKey(artical));

  @override
  Widget build(BuildContext context) {
    List<Widget> rowWidget = [];
    List<Tag> tags = artical.tags;
    tags.forEach((element) {
      rowWidget.add(_buildTagWidget(element.name));
      rowWidget.add(
          Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(6))));
    });
    rowWidget.add(_buildAuthorWidget(context));
    rowWidget.add(
        Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(10))));
    rowWidget.add(_buildTimeWidget(context));

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Theme.of(context).primaryColor,
          iconWidget: Icon(
            MyIcons.love,
            color: artical.collect ? Colors.yellow : Colors.white,
          ),
          onTap: () {},
        )
      ],
      child: InkWell(
        onTap: () {
          onArticalTap?.call(artical);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setWidth(8),
                  horizontal: ScreenUtil().setWidth(12)),
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Hero(
                          tag: artical.title,
                          child: Text(
                            artical.title,
                            style: titleTextStyle,
                            maxLines: 2,
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtil().setWidth(8)),
                      ),
                      Row(
                        children: rowWidget,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(8),
                  right: ScreenUtil().setWidth(8)),
              height: 1,
              color: Colors.black12,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTagWidget(String tag) {
    return Container(
      height: ScreenUtil().setWidth(16),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(4), right: ScreenUtil().setWidth(4)),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.greenAccent, width: ScreenUtil().setWidth(1)),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(2))),
      child: Center(
        child: Text(tag, style: tagTextStyle),
      ),
    );
  }

  Widget _buildAuthorWidget(BuildContext context) {
    var isYC = artical.author != "";
    if (isYC) {
      return Text("${S.of(context).author}${artical.author}");
    } else {
      return Text("${S.of(context).shareUser}${artical.shareUser}");
    }
  }

  Widget _buildTimeWidget(BuildContext context) {
    var isYC = artical.author != "";
    if (isYC) {
      return Text("${S.of(context).time}${artical.niceDate}");
    } else {
      return Text("${S.of(context).time}${artical.niceShareDate}");
    }
  }

  TextStyle titleTextStyle = TextStyle(fontSize: ScreenUtil().setSp(14));
  TextStyle tagTextStyle =
      TextStyle(fontSize: ScreenUtil().setSp(10), color: Colors.greenAccent);
  TextStyle authorTextStyle =
      TextStyle(fontSize: ScreenUtil().setSp(14), color: Colors.grey);
}

/**收藏按钮点击*/
typedef void OnCollectTap(Artical artical, int index);
/**chaperName按钮点击*/
typedef void OnChaperNameTap(String chapter);
/**tag按钮点击*/
typedef void OnTagTap(String tag);
/**文章点击*/
typedef void OnArticalTap(Artical artical);
