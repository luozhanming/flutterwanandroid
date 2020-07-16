import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef void BannerTapCallback(int index);

class BannerView extends StatefulWidget {

  /**
   * 显示items
   * */
  final List<BannerItem> items;

  /**
   * 是否自动轮播
   * */
  final bool canLoop;

  /**
   * 轮播周期
   * */
  final Duration duration;

  /**
   * 初始位置
   * */
  final int initPos;

  /**
   * 边界颜色
   * */
  final Color borderColor;

  /**
   * 边界宽度
   * */
  final double borderWidth;
  /**
   * 点击回调
   * */
  final BannerTapCallback callback;

  BannerView({this.items,
    this.canLoop = true,
    this.duration = const Duration(seconds: 5),
    this.initPos = 0,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.callback})
      : super(key: ObjectKey(items));

  @override
  _BannerState createState() => _BannerState();
}

class _BannerState extends State<BannerView> {
  String _msg = "";

  GlobalKey _pageViewKey = GlobalKey();

  //实际banner的真实元素位置
  int _curPos = 0;
  Timer _loopTimer;
  PageController _pageController;

  Queue<BannerItem> _tempItems = Queue();

  @override
  void initState() {
    super.initState();
    if (widget.items == null || widget.items.isEmpty) return;
    _curPos = widget.initPos;
    //文本初始化
    _msg = widget.items != null && widget.items.length > 0
        ? widget.items[_curPos].message
        : "";
    _loopTimer?.cancel();
    if (widget.canLoop) {
      _loopTimer = Timer.periodic(widget.duration, (timer) {
        log("BannerView loop", name: "BannerView");
        int curPagePos = _pageController.page.toInt();
        _pageController.animateToPage(curPagePos + 1,
            duration: Duration(milliseconds: 200), curve: Curves.linear);
      });
    }
    //因为有可能多次调用
    _pageController?.dispose();
    _pageController = PageController(initialPage: _curPos + 1);

    //为item指定真实位置
    //初始化副本items
    int len = widget.items.length;
    _tempItems.add(widget.items[len - 1]);
    for (int i = 0; i < len; i++) {
      widget.items[i].realPos = i;
      _tempItems.add(widget.items[i]);
    }

    List<BannerItem> items = _tempItems.toList();
    for (int i = 0, len = items.length; i < len; i++) {
      BannerItem item = items[i];
      widgets.add(Image(
        image: item.image,
        fit: BoxFit.cover,
      ));
    }

  }

  @override
  void dispose() {
    super.dispose();
    _loopTimer?.cancel();
    _pageController?.dispose();
  }
  List<Widget> widgets = [];
  @override
  Widget build(BuildContext context) {

    List<Widget> circles = [];
    if (_tempItems != null && _tempItems.isNotEmpty) {


      for (int i = 0, len = widget.items.length; i < len; i++) {
        circles.add(SizedBox(
          width: ScreenUtil().setWidth(10),
          height: ScreenUtil().setWidth(10),
          child: DecoratedBox(
            decoration: ShapeDecoration(
                shape: CircleBorder(
                    side: BorderSide(
                        color: _curPos == i ? Colors.yellow : Colors.white,
                        width: ScreenUtil().setWidth(5)))),
          ),
        ));
        circles.add(Padding(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
        ));
      }
    }
    if (widget.items == null && widget.items.isEmpty) {
      return Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(6))),
                side: BorderSide(
                    width: widget.borderWidth, color: widget.borderColor)),
          ),
          child: ClipRRect(
            borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().setWidth(2))),
            child:Image.asset("static/images/ic_pic.jpg",fit: BoxFit.fill))
      );
    } else
      return GestureDetector(
        onTap: () {
          widget.callback?.call(_curPos);
        },
        child: Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(6))),
                side: BorderSide(
                    width: widget.borderWidth, color: widget.borderColor)),
          ),
          child: ClipRRect(
            borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().setWidth(2))),
            child: Stack(
              children: <Widget>[
                PageView(
                  key: _pageViewKey,
                  controller: _pageController,
                  onPageChanged: (i) {
                    _onPageChanged(i);
                  },
                  scrollDirection: Axis.horizontal,
                  children: widgets,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
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
                              mainAxisSize: MainAxisSize.min,
                              children: circles,
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }

  void _onPageChanged(int i) {
    int flag = 0;
    setState(() {
      _curPos = _tempItems.toList()[i].realPos;
      _msg = widget.items != null && widget.items.length > 0
          ? widget.items[_curPos].message
          : "";
      int length = _tempItems.length;
      if (i == length - 1) {
        //滑到最后一个
        _tempItems.removeFirst();
        _tempItems.addLast(_tempItems.first);
        flag = -1;
        //    _pageController.jumpToPage(i-1);
      } else if (i == 0) {
        //滑到第一个
        _tempItems.removeLast();
        _tempItems.addFirst(_tempItems.last);
        flag = 1;
        //   _pageController.jumpToPage(i+1);
      }
    });

    //获取PageView的大小
    RenderBox box = _pageViewKey.currentContext.findRenderObject();
    var width = box.size.width;
    var offset  = _pageController.offset;
    if (flag > 0){
      _pageController.jumpTo(offset+width);
    } else if (flag < 0) {
      _pageController.jumpTo(offset-width);
    }
  }
}

class BannerItem {
  final ImageProvider image;

  final String message;

  int realPos = -1;

  BannerItem(this.image, {this.message = ""});
}
