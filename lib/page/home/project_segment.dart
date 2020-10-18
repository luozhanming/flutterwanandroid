import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/pager.dart';
import 'package:wanandroid/model/prochapter.dart';
import 'package:wanandroid/model/resource.dart';
import 'package:wanandroid/repository/project_repository.dart';

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
    return Builder(builder: (context){

      Resource<List<ProChapter>> chapters =
      context.select<ProjectViewModel, Resource<List<ProChapter>>>(
              (value) => value.chaptersRes);
      if (chapters != null && chapters.status == ResourceStatus.success) {
        var tabDatas = chapters.data;
        var tabs = getTabs(tabDatas);
        _tabController?.dispose();
        _tabController = TabController(initialIndex:mViewModel.selectedIndex,
            length: tabs.length, vsync: this);
        return Column(
          children: <Widget>[
            Container(
              height: ScreenUtil().setWidth(30),
              child: TabBar(
                isScrollable: true,
                controller: _tabController,
                //注意Provider作用域
                tabs: tabs,
                onTap: (index){

                },
              ),
            )
          ],
        );
      }else{
        return Container();
      }

    },);
  }

  @override
  ProjectViewModel buildViewModel(BuildContext context) {
    return ProjectViewModel(context);
  }

  List<Widget> getTabs(List<ProChapter> chapter) {
    List<Tab> tabs = [];
    chapter.forEach((element) {
      tabs.add(Tab(text: element.name,));
    });
    return tabs;
  }
}

class ProjectViewModel extends BaseViewModel {

  IProjectRepository _projectRepository;
  CompositeSubscription _subscriptions;

  Resource<List<ProChapter>> chaptersRes;

  Resource<Pager<Artical>> projectsRes;
  List<Artical> projects;

  int selectedIndex = 0;

  /**
   * 存放所选chapter加载的页码数
   * */
  Map<int,int> chapterIndexs;
  
  /**
   * 缓存每个chapter的数据
   * */
  Map<int,List<Artical>> chapterDatas;



  ProjectViewModel(BuildContext context) : super(context) {
    _projectRepository = RemoteProjectRepository();
    _subscriptions = CompositeSubscription();
  }

  @override
  void initState() {
    chapterIndexs = HashMap();
    chapterDatas = HashMap();
    loadProjectTree();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadProjectTree() {
    _subscriptions.add(_projectRepository.loadProjectTree().listen((event) {
      chaptersRes = event;
      loadProjects(true);
      notifyListeners();
    }, onError: (error) {}));
  }

  void loadProjects(bool isLoadMore) {
    var chapter = chaptersRes.data[selectedIndex];
    var page = 0;
    if (isLoadMore) {
      if (projectsRes != null) {
        page = projectsRes.data.curPage ;
      }
    }
    _subscriptions.add(_projectRepository.loadProject(chapter.id, page).listen((event) {
      projectsRes = event;

      notifyListeners();
    }, onError: (error) {}));
  }


  /**
   * 选择专题
   * */
  void selectChapter(int index){
    var chapters = chaptersRes.data;
    var chapter = chapters[index];

  }
}
