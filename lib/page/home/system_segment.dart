import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/model/pager.dart';
import 'package:wanandroid/model/resource.dart';
import 'package:wanandroid/model/system_knowlodge.dart';
import 'package:wanandroid/page/webview/webview_page.dart';
import 'package:wanandroid/repository/system_repository.dart';
import 'package:wanandroid/widget/artical_item_widget.dart';

class SystemSegment extends StatefulWidget {
  SystemSegment({Key key}) : super(key: key);

  @override
  _SystemSegmentState createState() => _SystemSegmentState();
}

class _SystemSegmentState extends BaseState<SystemSegment, SystemViewModel> {
  @override
  Widget buildBody(BuildContext context) {
    return PageView(
      controller: mViewModel._pageController,
      children: <Widget>[_buildChapterTree(), _buildChapterContent()],
    );
  }

  @override
  buildViewModel(BuildContext context) => SystemViewModel(context);

  _buildChapterTree() {
    return Builder(builder: (context) {
      var chaptersRes =
          context.select<SystemViewModel, Resource<List<SystemKnowlodge>>>(
              (value) => value.chapterRes);
      var selection = context.select<SystemViewModel, ChapterSelection>(
          (value) => value.selection);
      if (chaptersRes?.status == ResourceStatus.success) {
        //resource成功获取
        return Row(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var parentChapter = chaptersRes.data[index];
                  bool isSeleted = parentChapter == selection.parentChapter;
                  return _buildParentChapterItem(parentChapter, isSeleted);
                },
                itemCount: chaptersRes.data.length,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var parentChapter = selection.parentChapter;
                  var chapter = parentChapter.children[index];
                  bool isSeleted = chapter == selection.chapter;
                  return _bulidChapterItem(chapter, isSeleted);
                },
                itemCount: selection.parentChapter.children.length,
              ),
            )
          ],
        );
      } else {
        return Text("获取失败");
      }
    });
  }

  _buildChapterContent() {
    return Column(
      children: <Widget>[
        Builder(builder: (context) {
          var selection =
          context.select<SystemViewModel, ChapterSelection>(
                  (value) => value.selection);
          return Container(
            height: ScreenUtil().setWidth(30),
            color: Colors.yellow.shade50,
            child: GestureDetector(
              onTap: () {
                mViewModel.backToChapterTree();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                  ),
                  Icon(
                    Icons.chevron_left,
                    size: ScreenUtil().setWidth(28),
                  ),
                  Text(
                    "${selection.parentChapter.name}  →  ${selection.chapter.name}",
                    style: TextStyle(color: Colors.black87,fontSize: ScreenUtil().setSp(14),height: 1,fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }),
        Container(
          color: Colors.grey.shade400,
          height: 0.5,
        ),
        Builder(builder: (context) {
          var itemCount = context.select<SystemViewModel, int>(
                  (value) => value.articals.length);
          List<Artical> articals =
              context.select<SystemViewModel, List<Artical>>(
                  (value) => value.articals);
          return Expanded(
            child: SmartRefresher(
                controller: mViewModel._refreshController,
                enablePullUp: true,
                enablePullDown: true,
                onRefresh: () {
                  mViewModel.loadChapterArtical(false);
                },
                onLoading: () {
                  mViewModel.loadChapterArtical(true);
                },
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      var artical = articals[index];
                      return Builder(
                        builder:(context) {
                          var artical = articals[index];
                          bool isCollect = context.select<GlobalState,bool>((value) => value.loginUser!=null?artical.id==value.loginUser.collectIds.contains(artical.id):false);
                          artical.collect = isCollect;
                          return ArticalItemWidget(artical,
                            index: index,
                            isLogin: context.select<GlobalState, bool>((
                                value) => value.isLogin),
                            onArticalTap: (artical) async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      WebviewPage(
                                        url: artical.link,
                                        title: artical.title,
                                      )));
                            },);
                        }
                      );
                    },
                    itemCount: itemCount)),
          );
        }),
      ],
    );
  }

  _buildParentChapterItem(SystemKnowlodge parentChapter, bool isSeleted) {
    return Container(
      height: ScreenUtil().setWidth(30),
      decoration: BoxDecoration(
          color: isSeleted ? Colors.grey.shade300 : Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade200)),
      child: Material(
        color: Colors.transparent, //默认是白色，会遮盖上一层颜色
        child: InkWell(
          splashColor: Colors.grey.shade200,
          onTap: () async {
            mViewModel.selectChapter(parentChapter: parentChapter);
          },
          child: Container(
            alignment: Alignment.center,
            child: Text(parentChapter.name,
                style: TextStyle(fontSize: ScreenUtil().setSp(12))),
          ),
        ),
      ),
    );
  }

  _bulidChapterItem(SystemKnowlodge chapter, bool isSeleted) {
    return Container(
      height: ScreenUtil().setWidth(30),
      decoration: BoxDecoration(
          color: isSeleted ? Colors.grey.shade300 : Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade200)),
      child: Material(
        color: Colors.transparent, //默认是白色，会遮盖上一层颜色
        child: InkWell(
          splashColor: Colors.grey.shade200,
          onTap: () {
            mViewModel.selectChapter(chapter: chapter);
          },
          child: Container(
            alignment: Alignment.center,
            child: Text(chapter.name,
                style: TextStyle(fontSize: ScreenUtil().setSp(12))),
          ),
        ),
      ),
    );
  }
}

class SystemViewModel extends BaseViewModel {
  RefreshController _refreshController;
  PageController _pageController;
  SystemRepository _repository;
  CompositeSubscription _subscriptions;

  /*数据层*/
  ChapterSelection selection = ChapterSelection(false);

  Resource<List<SystemKnowlodge>> chapterRes;

  Resource<Pager<Artical>> articalPageRes;
  List<Artical> articals = [];

  SystemViewModel(BuildContext context) : super(context);

  @override
  void initState() {
    _refreshController = RefreshController();
    _pageController = PageController();
    _repository = SystemRepository();
    _subscriptions = CompositeSubscription();
    loadSystemTree();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _pageController.dispose();
    _subscriptions.dispose();
    super.dispose();
  }

  void loadSystemTree() {
    _repository.loadSystemTree().listen((event) {
      chapterRes = event;
      var data = event.data;
      //默认选第一个
      var defaultSelected = data[0];
      selection = ChapterSelection(true,
          parentChapter: defaultSelected, chapter: defaultSelected.children[0]);
      loadChapterArtical(false);
      notifyListeners();
    }, onError: (error) {
      if (error is Resource) {
        chapterRes = error;
      } else {
        chapterRes = Resource.error();
      }
      notifyListeners();
    });
  }

  void loadChapterArtical(bool isLoadMore) {
    var chapter = selection.chapter;
    var page = 0;
    if (isLoadMore) {
      if (articalPageRes != null) {
        page = articalPageRes.data.curPage ;
      }
    }
    _repository.loadSystemArtical(page, chapter.id).listen((event) {
      articalPageRes = event;
      var page = articalPageRes.data;
      if (!isLoadMore) {
        articals.clear();
        articals.addAll(page.datas);
        _refreshController.refreshCompleted(resetFooterState: true);
      } else {
        articals.addAll(page.datas);
        if(page.over){
          _refreshController.loadNoData();
        }else{
          _refreshController.loadComplete();
        }
      }
      notifyListeners();
    }, onError: (error) {
      if (error is Resource) {
        articalPageRes = error;
      } else {
        articalPageRes = Resource.error();
      }
      if (isLoadMore) {
        _refreshController.loadFailed();
      } else {
        _refreshController.refreshFailed();
      }
    });
  }

  /**
   * 选择专题
   * */
  void selectChapter({SystemKnowlodge parentChapter, SystemKnowlodge chapter}) {
    if (parentChapter != null && chapter != null)
      throw Exception(
          "Can not send parentChapter and chapter params at the same time.");
    if (parentChapter != null) {
      if (parentChapter == selection.parentChapter) return;
      selection = ChapterSelection(true,
          parentChapter: parentChapter, chapter: parentChapter.children[0]);
      loadChapterArtical(false);
      notifyListeners();
    } else if (chapter != null) {
      if (chapter == selection.chapter) return;
      selection = ChapterSelection(true,
          parentChapter: selection.parentChapter, chapter: chapter);
      loadChapterArtical(false);
      notifyListeners();
    }
  }

  void backToChapterTree() {
    _pageController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}

/**
 * 页面专题选择
 * */
class ChapterSelection {
  final bool hasSeleted;
  final SystemKnowlodge parentChapter;
  final SystemKnowlodge chapter;

  ChapterSelection(this.hasSeleted, {this.parentChapter, this.chapter});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterSelection &&
          runtimeType == other.runtimeType &&
          hasSeleted == other.hasSeleted &&
          parentChapter == other.parentChapter &&
          chapter == other.chapter;

  @override
  int get hashCode =>
      hasSeleted.hashCode ^ parentChapter.hashCode ^ chapter.hashCode;
}
