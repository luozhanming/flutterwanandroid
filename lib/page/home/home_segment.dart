import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/db/home_repository.dart';
import 'package:wanandroid/model/banner.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/widget/banner.dart';

class HomeSegment extends StatefulWidget {
  @override
  _HomeSegmentState createState() => _HomeSegmentState();
}

class _HomeSegmentState extends State<HomeSegment> {
  HomeSegmentViewModel _viewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        _viewModel = HomeSegmentViewModel();
        _viewModel.initState();
        return _viewModel;
      },
      builder: (context, child) => CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[_buildBanner(), _buildHomeArticals()],
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
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (context, index) {},
    ));
  }
}

class HomeSegmentViewModel extends BaseViewModel {
  List<HomeBanner> banners;
  CompositeSubscription _subscriptions;
  HomeModel _model;
  int page;

  @override
  void initState() {
    page = 0;
    _subscriptions = CompositeSubscription();
    _model = HomeModel();
    banners = [];
    loadBanner();
    loadHomeArticals();
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

  void loadHomeArticals() {
    _subscriptions.add(_model.loadHomeArticals(page)
    .listen((event) {
      event.toString();
    },onError: (error){

    }));
  }
}
