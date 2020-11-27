import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/styles.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/model/pager.dart';
import 'package:wanandroid/page/webview/webview_page.dart';
import 'package:wanandroid/repository/home_repository.dart';
import 'package:wanandroid/widget/artical_item_widget.dart';
import 'package:wanandroid/widget/common_appbar.dart';

class AuthorArticalPage extends StatefulWidget {
  static const NAME = "AuthorArticals";

  final String authorName;

  const AuthorArticalPage({this.authorName}) : assert(authorName != null);

  @override
  _AuthorArticalPageState createState() => _AuthorArticalPageState();
}

class _AuthorArticalPageState
    extends BaseState<AuthorArticalPage, AuthorArticalViewModel> {
  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(ScreenUtil().setWidth(Config.DESIGN_WIDTH),
            ScreenUtil().setWidth(40)),
        child: _buildAppBar(context),
      ),
      body: _buildContent(context),
    );
  }

  @override
  AuthorArticalViewModel buildViewModel(BuildContext context) {
    return AuthorArticalViewModel(context,widget.authorName);
  }

  _buildAppBar(BuildContext context) {
    return MyAppBar(
      leadingIcon: Icons.arrow_back,
      onLeadingIconTap: () => Navigator.pop(context),
      widget: Container(
        child: Text(
          widget.authorName,
          style: TextStyles.titleTextStyle,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SmartRefresher(
      controller: mViewModel._refreshController,
      enablePullUp: true,
      enablePullDown: true,
      onRefresh: () {
        mViewModel.loadArticals(false);
      },
      onLoading: () {
        mViewModel.loadArticals(true);
      },
      child: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[_buildAuthorArticals()],
      ),
    );
  }

  Widget _buildAuthorArticals() {
    return Builder(builder: (context) {
      var itemCount = context.select<AuthorArticalViewModel, int>(
          (value) => value.articals.length);
      bool isLogin =
          context.select<GlobalState, bool>((value) => value.isLogin);
      List<Artical> articals =
          context.select<AuthorArticalViewModel, List<Artical>>(
              (value) => value.articals);
      return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Builder(builder: (context) {
          var artical = articals[index];
          bool isCollect = context.select<GlobalState, bool>((value) =>
              value.loginUser != null
                  ? value.loginUser.collectIds.contains(artical.id)
                  : false);
          artical.collect = isCollect;
          return ArticalItemWidget(
            articals[index],
            isLogin: isLogin,
            index: index,
            onAuthorTap: (author) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AuthorArticalPage(
                        authorName: author,
                      )));
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
}

class AuthorArticalViewModel extends BaseViewModel {
  RefreshController _refreshController;

  CompositeSubscription _subscriptions;
  RemoteHomeRepository _homeRepository;

  final String author;
  List<Artical> articals = [];
  Pager<Artical> curPager;

  AuthorArticalViewModel(BuildContext context, this.author) : super(context);

  @override
  void initState() {
    _refreshController = RefreshController();
    _subscriptions = CompositeSubscription();
    _homeRepository = RemoteHomeRepository();
  }

  void loadArticals(bool isLoadMore) {
    int pageIndex = 0;
    if (isLoadMore && curPager != null) {
      pageIndex = curPager.curPage + 1;
    }
    _subscriptions.add(_homeRepository
        .searchAuthorArtical(author, pageIndex)
        .listen((event) {
          curPager = event;
          if(isLoadMore){
            articals.addAll(curPager.datas);
            if(curPager.over){
              _refreshController.loadNoData();
            }else{
              _refreshController.loadComplete();
            }
          }else{
            articals.clear();
            articals.addAll(curPager.datas);
            _refreshController.refreshCompleted(resetFooterState: true);
          }
          notifyListeners();
    },onError: (error){
          isLoadMore?_refreshController.loadFailed():_refreshController.refreshFailed();
    }));
  }
}
