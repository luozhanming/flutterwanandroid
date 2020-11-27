import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/common/base/event_bus.dart';
import 'package:wanandroid/common/my_network_image.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/banner.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/model/pager.dart';
import 'package:wanandroid/page/home/author_artical_page.dart';
import 'package:wanandroid/page/webview/webview_page.dart';
import 'package:wanandroid/repository/home_repository.dart';
import 'package:wanandroid/widget/artical_item_widget.dart';
import 'package:wanandroid/widget/banner.dart';

class HomeSegment extends StatefulWidget {
  @override
  _HomeSegmentState createState() => _HomeSegmentState();

  HomeSegment({Key key}) : super(key: key);
}

class _HomeSegmentState extends BaseState<HomeSegment, HomeSegmentViewModel> {
  ScrollController _scrollController;

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

  _lockToAwait() async {
    ///if loading, lock to await
    doDelayed() async {
      await Future.delayed(Duration(seconds: 1)).then((_) async {
        if (mViewModel.state == DataState.refresh) {
          return await doDelayed();
        } else {
          return null;
        }
      });
    }

    await doDelayed();
  }

  Widget _buildBanner() {
    return SliverToBoxAdapter(
      child: Container(
          margin: EdgeInsets.all(ScreenUtil().setWidth(8)),
          height: ScreenUtil().setWidth(200),
          child: Builder(builder: (context) {
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
              controller: mViewModel._bannerController,
            );
            //  }
          })),
    );
  }

  Widget _buildHomeArticals() {
    return Builder(builder: (context) {
      var itemCount = context
          .select<HomeSegmentViewModel, int>((value) => value.articals.length);
      bool isLogin =
          context.select<GlobalState, bool>((value) => value.isLogin);
      List<Artical> articals = context.select<HomeSegmentViewModel, List<Artical>>(
              (value) => value.articals);
      return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Builder(builder: (context) {
          var artical = articals[index];
          bool isCollect = context.select<GlobalState,bool>((value) => value.loginUser!=null?value.loginUser.collectIds.contains(artical.id):false);
          artical.collect = isCollect;
          return ArticalItemWidget(
            articals[index],
            isLogin: isLogin,
            index: index,
            onAuthorTap: (author){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>AuthorArticalPage(authorName: author,)));
            },
            onArticalTap: (artical) async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WebviewPage(
                        url: artical.link,
                        title: artical.title,
                      )));
            },
          );
        });
      }, childCount: itemCount));
    });
  }

//  Widget _articalItemBuilder(BuildContext context, int index) {
//    return Builder(builder: (context) {
//        //普通选项
//        Artical artical = context.select<HomeSegmentViewModel, Artical>(
//            (value) => value.articals[index]);
//        return ArticalItemWidget(
//          artical,
//          onArticalTap: (artical) async {
//            Navigator.of(context).push(MaterialPageRoute(
//                builder: (context) => WebviewPage(
//                      url: artical.link,
//                      title: artical.title,
//                    )));
//          },
//        );
//    });
//  }

  @override
  Widget buildBody(BuildContext context) {
    return SmartRefresher(
      controller: mViewModel._refreshController,
      enablePullUp: true,
      onRefresh: () {
        mViewModel.refreshData();
      },
      onLoading: () {
        mViewModel.loadHomeArticals(true);
      },
      child: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[_buildBanner(), _buildHomeArticals()],
      ),
    );
  }

  @override
  HomeSegmentViewModel buildViewModel(BuildContext context) {
    return HomeSegmentViewModel(context);
  }
}

class HomeSegmentViewModel extends BaseViewModel {
  BannerController _bannerController;
  RefreshController _refreshController;

  CompositeSubscription _subscriptions;
  RemoteHomeRepository _model;

  List<HomeBanner> banners;
  List<Artical> articals;
  Pager<Artical> curPager;

  HomeSegmentViewModel(BuildContext context) : super(context);

  @override
  void initState() {
    _bannerController = BannerController(BannerInfo(canLoop: true));
    _refreshController = RefreshController();
    _subscriptions = CompositeSubscription();
    _model = RemoteHomeRepository();
    banners = [];
    articals = [];
    refreshData();
    //接收到EventBus事件后，停止banner的滑动
    Bus.getEventBus().on<HomeIndexChangedEvent>().listen((event) {
      if (event.lastIndex != event.newIndex) {
        if (event.newIndex == 0) {
          _bannerController.startLoop();
        } else {
          _bannerController.stopLoop();
        }
      }
    });
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
    //同一时间只能有1个此类请求
    if (state == DataState.refresh || state == DataState.loadmore) return;
    state = isLoadMore ? DataState.loadmore : DataState.refresh;
    notifyListeners();
    _subscriptions.add(_model
        .loadHomeArticals(isLoadMore ? curPager?.curPage ?? 0 : 0)
        .listen((event) {
      if (isLoadMore) {
        if (curPager.curPage != event.curPage) {
          curPager = event;
          articals.addAll(event.datas);
          if (event.over) {
            _refreshController.loadNoData();
          } else {
            _refreshController.loadComplete();
          }
        }
      } else {
        //刷新
        articals.clear();
        articals.addAll(curPager.datas);
      }
      state = DataState.success;
      notifyListeners();
    }, onError: (error) {
      state = DataState.failed;
      notifyListeners();
    }));
  }

  void refreshData() {
    state = DataState.refresh;
    notifyListeners();
    List<Stream> streams = [_model.refreshBanner(), _model.loadHomeArticals(0)];
    _subscriptions.add(Rx.zip(streams, (values) {
      banners = values[0];
      curPager = values[1];
      articals.clear();
      articals.addAll(curPager.datas);
      state = DataState.success;
      _refreshController.refreshCompleted(resetFooterState: true);

      List<BannerItem> bannerItems = [];
      int length = banners.length;
      for (int i = 0; i < length; i++) {
        var banner = banners[i];
        bannerItems.add(
            BannerItem(MyNetWorkImage(banner.imagePath), message: banner.title));
      }
      _bannerController.refreshData(bannerItems);
      notifyListeners();
    }).listen((event) {}, onError: (error) {
      state = DataState.failed;
      _refreshController.refreshFailed();
      notifyListeners();
    }));
  }
}
