import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/db/home_repository.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/banner.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/model/pager.dart';
import 'package:wanandroid/widget/banner.dart';

class HomeSegment extends StatefulWidget {
  @override
  _HomeSegmentState createState() => _HomeSegmentState();
}

class _HomeSegmentState extends State<HomeSegment> {
  HomeSegmentViewModel _viewModel;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        _viewModel = HomeSegmentViewModel();
        _viewModel.initState();
        return _viewModel;
      },
      builder: (context, child) => NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: CustomScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          slivers: <Widget>[_buildBanner(), _buildHomeArticals()],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return SliverToBoxAdapter(
      child: Container(
          margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(8),
              left: ScreenUtil().setWidth(8),
              right: ScreenUtil().setWidth(8)),
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
      return SliverList(
          delegate: SliverChildBuilderDelegate(_articalItemBuilder,
              childCount: itemCount + 1));
    });
  }

  Widget _articalItemBuilder(BuildContext context, int index) {
    return Builder(builder: (context) {
      int state =
          context.select<HomeSegmentViewModel, int>((value) => value.state);
      if (state == BaseViewModel.STATE_LOADMORE &&
          index == _viewModel.articals.length) {
        //最后一个
        return Center(
          child: Text("加载更多...."),
        );
      } else {
        Artical artical = context.select<HomeSegmentViewModel, Artical>(
            (value) => value.articals[index]);
        return Center(
          child: Text(artical.title),
        );
      }
    });
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.extentAfter == 0.0) {
      //滑到最底部
      _viewModel.loadHomeArticals(true);
    } else if (notification.metrics.extentBefore == 0.0) {
      //滑到最顶部

    }
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
    if (curPager?.over ??
        false ||
            state == BaseViewModel.STATE_LOADING ||
            state == BaseViewModel.STATE_LOADMORE) return;
    state =
        isLoadMore ? BaseViewModel.STATE_LOADMORE : BaseViewModel.STATE_LOADING;
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
    List<Stream> streams = [_model.refreshBanner(), _model.loadHomeArticals(0)];
    _subscriptions.add(Rx.zip(streams, (values) {
      banners = values[0];
      curPager = values[1];
      articals.clear();
      articals.addAll(curPager.datas);
      state = BaseViewModel.STATE_SUCCESS;
      notifyListeners();
    }).doOnListen(() {
      state = BaseViewModel.STATE_LOADING;
      notifyListeners();
    }).listen((event) {}, onError: (error) {
      state = BaseViewModel.STATE_FAILED;
      notifyListeners();
    }));
  }
}
