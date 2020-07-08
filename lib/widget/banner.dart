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
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    if (widget.items != null && widget.items.isNotEmpty) {
      for (int i = 0, len = widget.items.length; i < len; i++) {
        BannerItem item = widget.items[i];
        widgets.add(Image(
          image: item.image,
          fit: BoxFit.cover,
        ));
      }
    }
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(6))),
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(6))),
                  side: BorderSide(width: ScreenUtil().setWidth(2))
          ),
        ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(4))),
            child: Stack(
              children: <Widget>[
                PageView(
                  scrollDirection: Axis.horizontal,
                  children: widgets,
                )
              ],
            ),
          ),
      ),
    );
  }
}

class BannerItem {
  final ImageProvider image;

  final String message;

  const BannerItem(this.image, {this.message});
}
