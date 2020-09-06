import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/common/styles.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/model/pager.dart';
import 'package:wanandroid/model/search_hot.dart';
import 'package:wanandroid/page/webview/webview_page.dart';
import 'package:wanandroid/repository/home_repository.dart';
import 'package:wanandroid/widget/artical_item_widget.dart';
import 'package:wanandroid/widget/common_appbar.dart';

class SearchPage extends StatefulWidget {
  static const String NAME = "Search";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends BaseState<SearchPage, SearchViewModel> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return MyAppBar(
      leadingIcon: Icons.arrow_back,
      onLeadingIconTap: () => Navigator.pop(context),
      widget: _buildSearchField(context),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: ScreenUtil().setWidth(16)),
      decoration: ShapeDecoration(
          color: Color.fromARGB(30, 0, 0, 0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(ScreenUtil().setWidth(15))))),
      height: ScreenUtil().setWidth(24),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(240),
            alignment: Alignment.centerLeft,
            child: TextField(
              controller: mViewModel._searchTextController,
              onSubmitted: (text){
                mViewModel.search(false);
              },
              textInputAction: TextInputAction.search,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(14), color: Colors.white),
              decoration: InputDecoration(
                hintText: S.of(context).search_website_content,
                hintStyle: TextStyle(color: Colors.white70),
                contentPadding:
                    EdgeInsets.only(left: ScreenUtil().setWidth(16)),
                enabledBorder: OutlineInputBorder(
                  /*边角*/
                  borderSide: BorderSide.none,
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().setWidth(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignLabelWithHint: true,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
            color: Colors.white70,
            width: ScreenUtil().setWidth(1),
            height: ScreenUtil().setWidth(18),
          ),
          Container(
            width: ScreenUtil().setWidth(40),
            height: ScreenUtil().setWidth(20),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                if (mViewModel._searchTextController.text.isNotEmpty) {
                  mViewModel.search(false);
                }
              },
              child: Icon(Icons.search,
                  size: ScreenUtil().setWidth(18), color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Builder(builder: (context) {
          bool searchEmpty = context
              .select<SearchViewModel, bool>((value) => value._searchEmpty);

          //1.搜索词为空   2.正在搜索   3.正在加载更多   4.无法搜索结果   5.正常
          if (searchEmpty) {
            //搜索词为空
            return Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(16),
                      top: ScreenUtil().setWidth(8)),
                  alignment: Alignment.topLeft,
                  child: Text(
                    S.of(context).search_hots,
                    style: TextStyles.h1TextStyle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(6)),
                ),
                _buildSearchHots(context),
                Container(
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(16),
                      top: ScreenUtil().setWidth(8)),
                  alignment: Alignment.topLeft,
                  child: Text(S.of(context).search_record,
                      style: TextStyles.h1TextStyle),
                )
              ],
            );
          } else {
            return SmartRefresher(
                controller: mViewModel._refreshController,
                enablePullUp: true,
                enablePullDown: true,
                onRefresh: () {
                  mViewModel.search(false);
                },
                onLoading: () {
                  mViewModel.search(true);
                },
                child: Builder(
                  builder: (context) {
                    var itemCount = context.select<SearchViewModel, int>(
                            (value) => value.searchDatas.length);
                    var articals = context.select<SearchViewModel,
                        List<Artical>>(
                            (value) => value.searchDatas);
                    var showNoData = context.select<SearchViewModel, bool>((value) => value.searchNoData);
                    if(showNoData){
                      return _buildNoSearchData();
                    }else{
                      return ListView.builder(
                          itemBuilder: (context, index) {
                            return _searchItemResultBuilder(
                                context, index, articals);
                          },
                          itemCount: itemCount);
                    }

                  }
                ));
          }
        }),
      ),
    );
  }

  Center _buildNoSearchData() => Center(child: Text("Empty Search"));

  @override
  buildViewModel(BuildContext context) {
    return SearchViewModel(context);
  }

  Widget _buildSearchHots(BuildContext context) {
    return Builder(builder: (context) {
      var hots = context
          .select<SearchViewModel, List<SearchHot>>((value) => value.hots);
      List<Widget> hotWidget = [];
      hots.forEach((element) {
        hotWidget.add(InputChip(
          label: Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setWidth(5),
                horizontal: ScreenUtil().setWidth(10)),
            child: Text(
              element.name,
              style: TextStyle(
                  height: 1,
                  fontSize: ScreenUtil().setWidth(12),
                  color: Colors.black54),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)),
              side: BorderSide(
                  width: 0, color: Colors.grey, style: BorderStyle.none)),
          onPressed: () {
            mViewModel._searchTextController.text = element.name;
            FocusScope.of(context).requestFocus(new FocusNode());
            mViewModel.search(false);
          },
        ));
      });
      return Wrap(
        spacing: ScreenUtil().setWidth(10),
        runSpacing: ScreenUtil().setWidth(5),
        children: <Widget>[...hotWidget],
      );
    });
  }

  /**
   * 创建搜索控件
   * */
  Widget _searchItemResultBuilder(
      BuildContext context, int index, List<Artical> articals) {
    return Builder(
      builder:(context)=> ArticalItemWidget(articals[index],
          index: index,
          isLogin: context.select<GlobalState, bool>((value) => value.isLogin),
          onArticalTap: (artical) async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WebviewPage(
                  url: artical.link,
                  title: artical.title,
                )));
      }),
    );
  }
}

class SearchViewModel extends BaseViewModel {
  TextEditingController _searchTextController;
  RefreshController _refreshController;

  //region s
  HomeModel _model;
  CompositeSubscription _subscriptions;
  StreamSubscription _searchSubscription;
  //end region
  //最近一次刷新的数据
  Pager<Artical> curPager;

  //搜索列表控件
  List<Artical> searchDatas = [];
  List<SearchHot> hots = [];
  bool _searchEmpty = true;
  bool searchNoData = false;

  SearchViewModel(BuildContext context) : super(context);

  @override
  void initState() {
    _model = HomeModel();
    _refreshController = RefreshController();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(_searchTextChanged);
    _subscriptions = CompositeSubscription();
    loadSearchHots();
  }

  _searchTextChanged() {
    //清空之前的搜索缓存
    bool isSearchChanged = _searchEmpty != _searchTextController.text.isEmpty;
    _searchEmpty = _searchTextController.text.isEmpty;
    _searchSubscription?.cancel();
    if (isSearchChanged) {
      searchDatas.clear();
      notifyListeners();
    }
  }

  void loadSearchHots() {
    _subscriptions.add(_model.loadSearchHot().listen((event) {
      hots = event;
      notifyListeners();
    }));
  }

  void search(bool isLoadMore) {
    var key = _searchTextController.text;
    var page = isLoadMore ? curPager.curPage : 0;

    _subscriptions.add(_model.searchArtical(key, page).listen((event) {
      curPager = event;
      if (event.isLoadMore()) {
        searchDatas.addAll(event.datas);
        if (event.over) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
      } else {
        if(event.datas==null||event.datas.length==0){
          searchNoData = true;
        }else{
          searchNoData = false;
          searchDatas.clear();
          searchDatas.addAll(event.datas);
          _refreshController.refreshCompleted(resetFooterState: true);
        }
      }
      notifyListeners();
    }));
  }

  @override
  void dispose() {
    _subscriptions.dispose();
    _searchTextController.dispose();
    _refreshController.dispose();
    super.dispose();
  }
}
