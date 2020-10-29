import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/pager.dart';
import 'package:wanandroid/model/prochapter.dart';
import 'package:wanandroid/model/resource.dart';
import 'package:wanandroid/repository/project_repository.dart';
import 'package:wanandroid/widget/artical_item_widget.dart';

class ProjectSegment extends StatefulWidget {
  @override
  _ProjectSegmentState createState() => _ProjectSegmentState();
}

class _ProjectSegmentState extends BaseState<ProjectSegment, ProjectViewModel>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Builder(
      builder: (context) {
        Resource<List<ProChapter>> chapters =
            context.select<ProjectViewModel, Resource<List<ProChapter>>>(
                (value) => value.chaptersRes);
        if (chapters != null && chapters.status == ResourceStatus.success) {
          var tabDatas = chapters.data;
          var tabs = getTabs(tabDatas);
          _tabController?.dispose();
          _tabController = TabController(
              initialIndex: mViewModel.selectedIndex,
              length: tabs.length,
              vsync: this);
          return Column(
            children: <Widget>[
              Container(
                height: ScreenUtil().setWidth(30),
                child: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  //注意Provider作用域
                  tabs: tabs,
                  onTap: (index) {
                    mViewModel.selectChapter(index);
                  },
                ),
              ),
              _buildProjectList()
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  ProjectViewModel buildViewModel(BuildContext context) {
    return ProjectViewModel(context);
  }

  List<Widget> getTabs(List<ProChapter> chapter) {
    List<Tab> tabs = [];
    chapter.forEach((element) {
      tabs.add(Tab(
        text: element.name,
      ));
    });
    return tabs;
  }

  Widget _buildProjectList() {
    return Expanded(
      child: Builder(builder: (context) {
        var projects = context
            .select<ProjectViewModel, List<Artical>>((value) => value.projects);
        return SmartRefresher(
            controller: mViewModel._refreshController,
            enablePullUp: true,
            enablePullDown: true,
            onRefresh: () {
              mViewModel.loadProjects(false);
            },
            onLoading: () {
              mViewModel.loadProjects(true);
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                var project = projects[index];
                return ArticalItemWidget(project);
              },
              itemCount: projects.length,
            ));
      }),
    );
  }
}

class ProjectViewModel extends BaseViewModel {
  IProjectRepository _projectRepository;
  CompositeSubscription _subscriptions;

  RefreshController _refreshController;

  Resource<List<ProChapter>> chaptersRes;

  Resource<Pager<Artical>> projectsRes;

  //显示中的项目
  List<Artical> projects;

  int selectedIndex = 0;

  /**
   * 存放所选chapter加载的页码数（id->page)
   * */
  Map<int, Resource<Pager<Artical>>> chapterIndexs;

  /**
   * 缓存每个chapter的数据
   * */
  Map<int, List<Artical>> chapterDatas;

  ProjectViewModel(BuildContext context) : super(context) {
    _projectRepository = RemoteProjectRepository();
    _subscriptions = CompositeSubscription();
    _refreshController = RefreshController();
  }

  @override
  void initState() {
    chapterIndexs = HashMap();
    chapterDatas = HashMap();
    loadProjectTree();
  }

  @override
  void dispose() {
    _subscriptions.dispose();
    super.dispose();
  }

  void loadProjectTree() {
    _subscriptions.add(_projectRepository.loadProjectTree().listen((event) {
      chaptersRes = event;
      //选择默认的chapter
      var chapters = event.data;
      //初始化各个专题页码
      chapters.forEach((element) {
        chapterIndexs[element.id] = null;
        chapterDatas[element.id] = [];
      });
      loadProjects(false);
      notifyListeners();
    }, onError: (error) {}));
  }

  void loadProjects(bool isLoadMore) {
    var chapter = chaptersRes.data[selectedIndex];
    var page = 1;
    if (isLoadMore) {
      page = chapterIndexs[chapter.id]?.data?.curPage ?? 0 + 1;
    }
    _subscriptions
        .add(_projectRepository.loadProject(chapter.id, page).listen((event) {
      projectsRes = event;
      chapterIndexs.remove(chapter.id);
      chapterIndexs[chapter.id] = projectsRes;
      var showDatas = chapterDatas[chapter.id];
      if (isLoadMore) {
        //加载更多成功
        if (projectsRes.data.datas.isNotEmpty) {
          _refreshController.loadComplete();
          showDatas.addAll(projectsRes.data.datas);
        } else {
          _refreshController.loadNoData();
        }
      } else {
        //刷新成功
        _refreshController.refreshCompleted(resetFooterState: true);
        showDatas.clear();
        showDatas.addAll(projectsRes.data.datas);
      }
      projects = showDatas;
      notifyListeners();
    }, onError: (error) {
      if (isLoadMore)
        _refreshController.loadFailed();
      else
        _refreshController.refreshFailed();
    }));
  }

  /**
   * 选择专题
   * */
  void selectChapter(int index) {
    selectedIndex = index;
    var chapters = chaptersRes.data;
    var chapter = chapters[index];
    var articals = chapterDatas[chapter.id];
    projectsRes = chapterIndexs[chapter.id];
    if (articals.isNotEmpty) {
      loadProjects(false);
    } else {
      projects = articals;
      notifyListeners();
    }
  }
}
