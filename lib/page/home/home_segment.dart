import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/db/home_repository.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/banner.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/model/pager.dart';
import 'package:wanandroid/page/webview/webview_page.dart';
import 'package:wanandroid/widget/artical_item_widget.dart';
import 'package:wanandroid/widget/banner.dart';

class HomeSegment extends StatefulWidget {
  @override
  _HomeSegmentState createState() => _HomeSegmentState();

  HomeSegment({Key key}) : super(key: key);
}

class _HomeSegmentState extends BaseState<HomeSegment, HomeSegmentViewModel> {
  ScrollController _scrollController;
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> _waitLoading() async {
    await Future.doWhile(() async {
     return mViewModel.state == BaseViewModel.STATE_REFRESH;
    });
  }

  Widget _buildBanner() {
    return SliverToBoxAdapter(
      child: Container(
          margin: EdgeInsets.all(ScreenUtil().setWidth(8)),
          height: ScreenUtil().setWidth(200),
          child: Builder(builder: (context) {
            List<BannerItem> items = [];
            List<HomeBanner> banners =
                context.select<HomeSegmentViewModel, List<HomeBanner>>(
                    (value) => value.banners);
            int length = banners.length;
            for (int i = 0; i < length; i++) {
              var banner = banners[i];
              items.add(BannerItem(NetworkImage(banner.imagePath),
                  message: banner.title));
            }
            return BannerView(
              callback: (index) async {
                var banner = mViewModel.banners[index];
                var url = banner.url;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WebviewPage(
                          url: url,
                          title: banner.title,
                        )));
              },
              borderWidth: ScreenUtil().setWidth(6),
              borderColor: context
                  .select<GlobalState, ThemeData>((value) => value.themeData)
                  .primaryColor,
              items: items,
            );
            //  }
          })),
    );
  }

  Widget _buildHomeArticals() {
    return Builder(builder: (context) {
      int itemCount = context
          .select<HomeSegmentViewModel, int>((value) => value.articals.length);
      //没有更多或加载更多状态，item视图加一
      int state =
          context.select<HomeSegmentViewModel, int>((value) => value.state);
      if (state == BaseViewModel.STATE_NOMORE ||
          state == BaseViewModel.STATE_LOADMORE) {
        itemCount++;
      }
      return SliverList(
          delegate: SliverChildBuilderDelegate(_articalItemBuilder,
              childCount: itemCount));
    });
  }

  Widget _articalItemBuilder(BuildContext context, int index) {
    return Builder(builder: (context) {
      //数据为空
      int state =
          context.select<HomeSegmentViewModel, int>((value) => value.state);
      if (mViewModel.articals.isEmpty) {
        return Center();
      } else if (state == BaseViewModel.STATE_LOADMORE &&
          index == mViewModel.articals.length) {
        //加载更多视图
        return Container(
          alignment: Alignment.center,
          height: 60,
          child: Text("加载更多...."),
        );
      } else {
        //普通选项
        Artical artical = context.select<HomeSegmentViewModel, Artical>(
            (value) => value.articals[index]);
        return ArticalItemWidget(
          artical,
          onArticalTap: (artical) async {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => WebviewPage(
                      url: artical.link,
                      title: artical.title,
                    )));
          },
        );
      }
    });
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.extentAfter == 0.0) {
      //滑到最底部
      mViewModel.loadHomeArticals(true);
    } else if (notification.metrics.extentBefore == 0.0) {
      //滑到最顶部
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: RefreshIndicator(
        onRefresh: () async {
          mViewModel.refreshData();
          await _waitLoading();
        },
        child: CustomScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          slivers: <Widget>[_buildBanner(), _buildHomeArticals()],
        ),
      ),
    );
  }

  @override
  HomeSegmentViewModel buildViewModel(BuildContext context) {
    return HomeSegmentViewModel();
  }
}

class HomeSegmentViewModel extends BaseViewModel {
  CompositeSubscription _subscriptions;
  HomeModel _model;

  List<HomeBanner> banners;
  List<Artical> articals;
  Pager<Artical> curPager;

  @override
  void initState() {
    _subscriptions = CompositeSubscription();
    _model = HomeModel();
    banners = [];
    articals = [];
    refreshData();
    // loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _subscriptions.dispose();
  }

  void loadBanner() {
    _subscriptions.add(_model.refreshBanner().listen((event) {
      banners = event;
      notifyListeners();
    }, onError: (error) {}));
  }

  void loadHomeArticals(bool isLoadMore) {
    //没有更多数据
    if (curPager?.over ?? false) {
      state = BaseViewModel.STATE_NOMORE;
      notifyListeners();
    }
    //同一时间只能有1个此类请求
    if (state == BaseViewModel.STATE_REFRESH ||
        state == BaseViewModel.STATE_LOADMORE) return;
    state =
        isLoadMore ? BaseViewModel.STATE_LOADMORE : BaseViewModel.STATE_REFRESH;
    notifyListeners();
    _subscriptions.add(_model
        .loadHomeArticals(isLoadMore ? curPager?.curPage ?? 0 + 1 : 0)
        .listen((event) {
      if (isLoadMore) {
        if (curPager.curPage != event.curPage) {
          curPager = event;
          articals.addAll(event.datas);
        }
      } else {
        articals.clear();
        articals.addAll(curPager.datas);
      }
      state = BaseViewModel.STATE_SUCCESS;
      notifyListeners();
    }, onError: (error) {
      state = BaseViewModel.STATE_FAILED;
      notifyListeners();
    }));
  }

  void refreshData() {
    state = BaseViewModel.STATE_REFRESH;
    notifyListeners();
    List<Stream> streams = [_model.refreshBanner(), _model.loadHomeArticals(0)];
    _subscriptions.add(Rx.zip(streams, (values) {
      banners = values[0];
      curPager = values[1];
      articals.clear();
      articals.addAll(curPager.datas);
      state = BaseViewModel.STATE_SUCCESS;
      notifyListeners();
    }).listen((event) {}, onError: (error) {
      state = BaseViewModel.STATE_FAILED;
      notifyListeners();
    }));
  }
}
