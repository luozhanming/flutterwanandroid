import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BannerView extends StatefulWidget {
  List<BannerItem> items;

  BannerView({this.items});

  @override
  _BannerState createState() => _BannerState();
}

class _BannerState extends State<BannerView> {
  String _msg = "";
  int _curPos=0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    List<Widget> circles = [];
    if (widget.items != null && widget.items.isNotEmpty) {
      for (int i = 0, len = widget.items.length; i < len; i++) {
        BannerItem item = widget.items[i];
        widgets.add(Image(
          image: item.image,
          fit: BoxFit.cover,
        ));

        circles.add(SizedBox(
          width: ScreenUtil().setWidth(10),
          height: ScreenUtil().setWidth(10),
          child: DecoratedBox(
            decoration: ShapeDecoration(
                shape: CircleBorder(
                    side: BorderSide(
                        color:_curPos==i?Colors.yellow:Colors.white,
                        width: ScreenUtil().setWidth(5)))),
          ),
        ));
        circles.add(Padding(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
        ));
      }

    }



    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(6))),
            side: BorderSide(
                width: ScreenUtil().setWidth(4), color: Colors.yellow)),
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().setWidth(4))),
        child: Stack(
          children: <Widget>[
            PageView(
              controller: PageController(initialPage: _curPos),
              onPageChanged: (i) {
                String message = widget.items[i].message;
                setState(() {
                  _msg = message;
                  _curPos = i;
                });
              },
              scrollDirection: Axis.horizontal,
              children: widgets,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: ScreenUtil().setWidth(20),
                color: Color.fromARGB(128, 0, 0, 0),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(8)),
                        child: Text(
                          _msg,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: circles,
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BannerItem {
  final ImageProvider image;

  final String message;

  const BannerItem(this.image, {this.message = ""});
}
