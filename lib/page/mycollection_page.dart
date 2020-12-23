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
import 'package:wanandroid/model/pager.dart';
import 'package:wanandroid/model/resource.dart';
import 'package:wanandroid/repository/collect_repository.dart';
import 'package:wanandroid/widget/common_appbar.dart';

class MyCollectionPage extends StatefulWidget {
  static const String NAME = "/mycollection";

  @override
  _MyCollectionPageState createState() => _MyCollectionPageState();
}

class _MyCollectionPageState
    extends BaseState<MyCollectionPage, _MyCollectionViewModel> {
  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildCollectionList(),
    );
  }

  @override
  _MyCollectionViewModel buildViewModel(BuildContext context) {
    return _MyCollectionViewModel(context);
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return MyAppBar(
      leadingIcon: Icons.arrow_back,
      onLeadingIconTap: () => Navigator.pop(context),
      widget: Text(
        S.of(context).my_collection,
        style: TextStyles.titleTextStyle,
      ),
    );
  }

  Widget _buildCollectionList() {
    return Builder(
      builder: (context) {
        var itemCount = context.select<_MyCollectionViewModel, int>(
            (value) => value.articals.length);
        return SmartRefresher(
            //child不能是Builder
            controller: mViewModel._refreshController,
            enablePullUp: true,
            onRefresh: () {
              mViewModel.loadMyCollections(false);
            },
            onLoading: () {
              mViewModel.loadMyCollections(true);
            },
            child: ListView.builder(
                itemBuilder: (context, index) {
                  if (itemCount == 0) {
                    return _buildEmptyDataView(context);
                  } else {
                    return _buildListItem(context,index);
                  }
                },
                itemCount:  1 ));
      },
    );
  }

  Widget _buildEmptyDataView(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(360),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: Text("sdfsdf"))
          ]),
    );
  }

  Widget _buildListItem(BuildContext context,int index) {
    Artical articals = context.select<_MyCollectionViewModel, Artical>(
            (value) => value.articals[index]);
    return Builder(
      builder: (context){
        return Container()
      },
    );
  }
}

class _MyCollectionViewModel extends BaseViewModel {
  _MyCollectionViewModel(BuildContext context) : super(context);
  RefreshController _refreshController;
  ICollectionsRepository _repository;
  CompositeSubscription _subscriptions;
  Resource<Pager<Artical>> articalPageRes;
  List<Artical> articals = [];

  @override
  void initState() {
    _refreshController = RefreshController();
    _repository = RemoteCollectionsRepository();
    _subscriptions = CompositeSubscription();
    loadMyCollections(false);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _subscriptions.dispose();
    super.dispose();
  }

  void loadMyCollections(bool isLoadMore) {
    var page = 0;
    if (isLoadMore) {
      if (articalPageRes != null) {
        page = articalPageRes.data.curPage;
      }
    }
    _subscriptions.add(_repository.loadMyCollections(page).listen((event) {
      articalPageRes = event;
      var page = articalPageRes.data;
      if (!isLoadMore) {
        articals.clear();
        articals.addAll(page.datas);
        _refreshController.refreshCompleted(resetFooterState: true);
      } else {
        articals.addAll(page.datas);
        if (page.over) {
          _refreshController.loadNoData();
        } else {
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
    }));
  }
}
