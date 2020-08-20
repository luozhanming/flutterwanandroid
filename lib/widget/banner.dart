import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanandroid/common/base/route_widget.dart';

typedef void BannerTapCallback(int index);

class BannerView extends StatefulWidget with RouteAware {
  final bool canLoop;

  final Duration duration;

  final int initPos;

  final Color borderColor;

  final double borderWidth;

  final BannerTapCallback callback;

  final BannerController controller;

  BannerView(
      {this.canLoop = true,
      this.duration = const Duration(seconds: 5),
      this.initPos = 0,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0,
      this.controller,
      this.callback});

  @override
  BannerState createState() => BannerState();
}

class BannerState extends RouteAwareWidgetState<BannerView> {
  //显示当前广告文字
  String _msg = "";

  //实际banner的真实元素位置
  int _curPos = 0;

  //定时器
  Timer _loopTimer;
  PageController _pageController;

  //显示的假数据，用于轮播循环逻辑
  Queue<BannerItem> tempItems = Queue();
  //当相同时不会重新渲染
  GlobalKey _pagerKey;

  @override
  void initState() {
    super.initState();
    //初次构建不会有实际数据
    widget.controller.addListener(() {
      setState(() {
        var items = widget.controller.value.items;
        if (items.isEmpty) return;
        _pagerKey = GlobalKey();
        _pageController?.dispose();
        _pageController = PageController(initialPage: 1);
        _curPos = 0;
        if (items == null || items.isEmpty) return;
        //文本初始化
        _msg = items != null && items.length > 0 ? items[0].message : "";
        //为item指定真实位置
        //初始化副本items
        int len = items.length;
        tempItems.clear();
        tempItems.add(items[len - 1]);
        for (int i = 0; i < len; i++) {
          items[i].realPos = i;
          tempItems.add(items[i]);
        }
        if (widget.canLoop) {
          startLoop(widget.controller.value.canLoop);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.dispose();
    _pageController?.dispose();
    startLoop(false);
  }

  @override
  void didPopNext() {
    startLoop(true);
  }

  @override
  void didPushNext() {
    startLoop(false);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    List<Widget> circles = [];
    var realItems = widget.controller.value.items;
    if (realItems == null || realItems.isEmpty) {
      return _buildEmpty();
    }

    //重建Banner内容widget
    List<BannerItem> items = tempItems.toList();
    for (int i = 0, len = items.length; i < len; i++) {
      BannerItem item = items[i];
      widgets.add(Image(
        image: item.image,
        fit: BoxFit.cover,
      ));
    }
    //构建指示点
    for (int i = 0, len = realItems.length; i < len; i++) {
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
                key: _pagerKey,
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

  //构建空白视图
  Widget _buildEmpty() => Center(child: Text("empty"));

  void _onPageChanged(int i) {
    int flag = 0;
    setState(() {
      var realItems = widget.controller.value.items;
      _curPos = tempItems.toList()[i].realPos;
      _msg = realItems != null && realItems.length > 0
          ? realItems[_curPos].message
          : "";
      int length = tempItems.length;
      if (i == length - 1) {
        //滑到最后一个
        tempItems.removeFirst();
        tempItems.addLast(tempItems.first);
        flag = -1;
        //    _pageController.jumpToPage(i-1);
      } else if (i == 0) {
        //滑到第一个
        tempItems.removeLast();
        tempItems.addFirst(tempItems.last);
        flag = 1;
        //   _pageController.jumpToPage(i+1);
      }
    });
    RenderBox box = _pagerKey.currentContext.findRenderObject();
    var width = box.size.width;
    var offset = _pageController.offset;
    if (flag > 0)
      _pageController.jumpTo(offset + width);
    else if (flag < 0) {
      _pageController.jumpTo(offset - width);
    }
  }

  void startLoop(bool start) {
    if (start) {
      _loopTimer?.cancel();
      if (widget.canLoop) {
        _loopTimer = Timer.periodic(widget.duration, (timer) {
          log("BannerView loop", name: "BannerView");
          int curPagePos = _pageController.page.toInt();
          _pageController.animateToPage(curPagePos + 1,
              duration: Duration(milliseconds: 200), curve: Curves.linear);
        });
      }
    } else {
      _loopTimer?.cancel();
    }
  }
}

class BannerItem {
  final ImageProvider image;

  final String message;

  int realPos = -1;

  BannerItem(this.image, {this.message = ""});
}

/**
 * Banner控制器
 * */
class BannerController extends ValueNotifier<BannerInfo> {
  BannerController(BannerInfo value) : super(value);

  void refreshData(List<BannerItem> datas) {
    value.items = datas;

    notifyListeners();
  }

  void startLoop() {
    value.canLoop = true;
    notifyListeners();
  }

  void stopLoop() {
    value.canLoop = false;
    notifyListeners();
  }

  void dispose() {
    value.items.clear();
  }
}

class BannerInfo {
  List<BannerItem> items = [];
  bool canLoop = true;

  BannerInfo({this.canLoop});
}
