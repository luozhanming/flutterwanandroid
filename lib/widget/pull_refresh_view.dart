import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PullToRefreshView extends StatefulWidget {

  ///item渲染
  final IndexedWidgetBuilder itemBuilder;
  final RefreshFunction onRefresh;

  final RefreshFunction onLoadMore;

  final PullToRefreshController controller;

  final Key refreshKey;

  PullToRefreshView({this.onRefresh, this.onLoadMore, this.controller, this.itemBuilder, this.refreshKey});

  @override
  _PullToRefreshViewState createState() => _PullToRefreshViewState();
}

class _PullToRefreshViewState extends State<PullToRefreshView> {

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    widget.controller?.needLoadMore?.addListener(() {
      ///延迟两秒等待确认
      try {
        Future.delayed(Duration(seconds: 2), () {
          // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
          _scrollController.notifyListeners();
        });
      } catch (e) {
        print(e);
      }
    });
  }

  _scrollListener(){
     ///判断当前滑动位置是不是到达底部，触发加载更多回调
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (widget?.controller?.needLoadMore?.value == true) {
        widget?.onLoadMore?.call();
      }
    }
  }


  ///根据配置状态返回实际列表数量
  ///实际上这里可以根据你的需要做更多的处理
  ///比如多个头部，是否需要空页面，是否需要显示加载更多。
  _getListCount() {
    ///是否需要头部
    if (widget.controller.needHeader) {
      ///如果需要头部，用Item 0 的 Widget 作为ListView的头部
      ///列表数量大于0时，因为头部和底部加载更多选项，需要对列表数据总数+2
      return (widget.controller.dataList.length > 0)
          ? widget.controller.dataList.length + 2
          : widget.controller.dataList.length + 1;
    } else {
      ///如果不需要头部，在没有数据时，固定返回数量1用于空页面呈现
      if (widget.controller.dataList.length == 0) {
        return 1;
      }

      ///如果有数据,因为部加载更多选项，需要对列表数据总数+1
      return (widget.controller.dataList.length > 0)
          ? widget.controller.dataList.length + 1
          : widget.controller.dataList.length;
    }
  }


  ///根据配置状态返回实际列表渲染Item
  _getItem(int index) {
    if (!widget.controller.needHeader &&
        index == widget.controller.dataList.length &&
        widget.controller.dataList.length != 0) {
      ///如果不需要头部，并且数据不为0，当index等于数据长度时，渲染加载更多Item（因为index是从0开始）
      return _buildProgressIndicator();
    } else if (widget.controller.needHeader &&
        index == _getListCount() - 1 &&
        widget.controller.dataList.length != 0) {
      ///如果需要头部，并且数据不为0，当index等于实际渲染长度 - 1时，渲染加载更多Item（因为index是从0开始）
      return _buildProgressIndicator();
    } else if (!widget.controller.needHeader &&
        widget.controller.dataList.length == 0) {
      ///如果不需要头部，并且数据为0，渲染空页面
      return _buildEmpty();
    } else {
      ///回调外部正常渲染Item，如果这里有需要，可以直接返回相对位置的index
      return widget.itemBuilder(context, index);
    }
  }

  ///上拉加载更多
  Widget _buildProgressIndicator() {
    ///是否需要显示上拉加载更多的loading
    Widget bottomWidget = (widget.controller.needLoadMore.value)
        ? new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///loading框

          new Container(
            width: 5.0,
          ),

          ///加载中文本
          new Text(
            "加载更多",
            style: TextStyle(
              color: Color(0xFF121917),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          )
        ])

    /// 不需要加载
        : new Container();
    return new Padding(
      padding: const EdgeInsets.all(20.0),
      child: new Center(
        child: bottomWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      ///GlobalKey，用户外部获取RefreshIndicator的State，做显示刷新
      key: widget.refreshKey,

      ///下拉刷新触发，返回的是一个Future
      onRefresh: widget.onRefresh,
      child: new ListView.builder(
        ///保持ListView任何情况都能滚动，解决在RefreshIndicator的兼容问题。
        physics: const AlwaysScrollableScrollPhysics(),

        ///根据状态返回子孔健
        itemBuilder: (context, index) {
          return _getItem(index);
        },

        ///根据状态返回数量
        itemCount: _getListCount(),

        ///滑动监听
        controller: _scrollController,
      ),
    );
  }

  _buildEmpty() {}
}










class PullToRefreshController{
  ///数据，对齐增减，不能替换
  List dataList = new List();

  ///是否需要加载更多
  ValueNotifier<bool> needLoadMore = new ValueNotifier(false);

  ///是否需要头部
  bool needHeader = false;
}

typedef RefreshFunction = void Function();

