import 'dart:developer';

import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/common/base/event_bus.dart';
import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/my_icons.dart';
import 'package:wanandroid/database/db_manager.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/model/user.dart';
import 'package:wanandroid/page/home/home_segment.dart';
import 'package:wanandroid/page/home/project_segment.dart';
import 'package:wanandroid/page/home/system_segment.dart';
import 'package:wanandroid/page/login/login_page.dart';
import 'package:wanandroid/page/search/search_page.dart';
import 'package:wanandroid/widget/circle_widget.dart';

class HomePage extends StatefulWidget {
  static const String NAME = "/";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage, _HomeViewModel> {
  _HomeViewModel mViewModel;
  List<Widget> _tabList = [];

  @override
  void initState() {
    super.initState();
    _tabList.addAll([
      AnimatedSwitcher(
        child: HomeSegment(),
        duration: const Duration(milliseconds: 300),
      ),
      AnimatedSwitcher(
        child: SystemSegment(),
        duration: const Duration(milliseconds: 300),
      ),
      AnimatedSwitcher(
        child: ProjectSegment(),
        duration: const Duration(milliseconds: 300),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _tabList.clear();
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Center(),
      flexibleSpace: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Center(
          child: Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(8))),
              Builder(
                //将context范围缩到Scaffold
                builder: (context) => InkWell(
                  onTap: () {
                    //   Navigator.of(context).pushNamed(LoginPage.NAME);
                    Scaffold.of(context).openDrawer();
                  },
                  child: OvalWidget(
                      width: ScreenUtil().setWidth(30),
                      height: ScreenUtil().setWidth(30),
                      child: Image.asset(
                        "${Config.PATH_IMAGE}ic_pic.jpg",
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(8))),
              Expanded(
                //尽可能的占满主轴剩余位置
                child: Container(
                  height: ScreenUtil().setWidth(26),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(40, 0, 0, 0),
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(3))),
                      border: Border.all(color: Colors.black12)),
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(8)),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Color.fromARGB(40, 0, 0, 0),
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(3))),
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPage()));
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                          child: Icon(Icons.search,
                              size: ScreenUtil().setWidth(20),
                              color: context
                                  .select<GlobalState, ThemeData>(
                                      (value) => value.themeData)
                                  .primaryTextTheme
                                  .title
                                  .color),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                          child: Text(
                            S.of(context).search_website_content,
                            style: TextStyle(
                                //解决Text不对齐问题
                                height: 1,
                                fontSize: ScreenUtil().setSp(14),
                                color: context
                                    .select<GlobalState, ThemeData>(
                                        (value) => value.themeData)
                                    .primaryTextTheme
                                    .title
                                    .color),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ), //// AppBar是固定56高度的
    );
  }

  List<FFNavigationBarItem> getNavigationBarItems() {
    List<FFNavigationBarItem> items = [];
    items.add(FFNavigationBarItem(
      iconData: Icons.home,
      label: S.of(context).home,
    ));
    items.add(FFNavigationBarItem(
      iconData: MyIcons.tree,
      label: S.of(context).tixi,
    ));
    items.add(FFNavigationBarItem(
      iconData: MyIcons.project,
      label: S.of(context).project,
    ));
    return items;
  }

  @override
  Widget buildBody(BuildContext context) {
    ScreenUtil.init(context, width: Config.DESIGN_WIDTH);
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      drawer: _buildDrawer(),
      appBar: PreferredSize(
        preferredSize: Size(ScreenUtil().setWidth(Config.DESIGN_WIDTH),
            ScreenUtil().setWidth(40)),
        child: _buildAppBar(context),
      ),
      bottomNavigationBar: Consumer<_HomeViewModel>(
        builder: (context, value, child) => FFNavigationBar(
          selectedIndex: value.selectedIndex,
          theme: FFNavigationBarTheme(
              selectedItemBackgroundColor: Theme.of(context).primaryColor,
              showSelectedItemShadow: false,
              barHeight: ScreenUtil().setWidth(36),
              itemWidth: ScreenUtil().setWidth(30)),
          items: getNavigationBarItems(),
          onSelectTab: (index) {
            value.changeSelectedIndex(index);
          },
        ),
      ),
      body: Builder(builder: (context) {
        int selecteIndex =
            context.select<_HomeViewModel, int>((value) => value.selectedIndex);
        return IndexedStack(
          index: selecteIndex,
          children: _tabList,
        );
      }),
    );
  }

  @override
  _HomeViewModel buildViewModel(BuildContext context) {
    return _HomeViewModel(context);
  }

  Widget _buildDrawer() {
    return Builder(builder: (context) {
      bool isLogin =
          context.select<GlobalState, bool>((value) => value.isLogin);
      User user = context.select<GlobalState, User>((value) => value.loginUser);
      return Container(
        alignment: Alignment.center,
        color: Color.fromARGB(255, 240, 240, 240),
        width: ScreenUtil().setWidth(200),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: (MediaQuery.of(context).padding.top) +
                      ScreenUtil().setWidth(8),
                  bottom: ScreenUtil().setWidth(8)),
              color: context.select<GlobalState, Color>(
                  (value) => value.themeData.primaryColor),
              child: GestureDetector(
                onTap: () {
                  var isLogin = context.read<GlobalState>().isLogin;
                  if (!isLogin) {
                    Navigator.of(context).pushNamed(LoginPage.NAME);
                  }
                },
                child: Column(
                  children: <Widget>[
                    OvalWidget(
                      boarderColor: Colors.grey,
                      width: ScreenUtil().setWidth(50),
                      height: ScreenUtil().setWidth(50),
                      child: isLogin
                          ? Image.asset("static/images/ic_pic.jpg")
                          : Image.asset("static/images/ic_pic.jpg"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setWidth(8)),
                    ),
                    Text(
                      isLogin ? user.nickname : "点击头像登录",
                      style: TextStyle(
                          fontSize: ScreenUtil().setWidth(18),
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            FlatButton(
              child: Text("注销"),
              onPressed: (){
                mViewModel.logout();
              },
            )
          ],
        ),
      );
    });
  }
}

class _HomeViewModel extends BaseViewModel {
  int selectedIndex;

  _HomeViewModel(BuildContext context) : super(context);

  void dispose() {
    super.dispose();
  }

  void changeSelectedIndex(index) {
    //flutter因为没有像Android那样的fragment的生命周期，所以切换这种要保留状态的需要这样发送事件
    Bus.getEventBus().fire(HomeIndexChangedEvent(selectedIndex, index));
    selectedIndex = index;
    notifyListeners();
  }

  @override
  void initState() {
    selectedIndex = 0;
    var loadSp = () async {
      var dao = UserLoginDao();
      var list = await dao.query();
      if (list != null && list.length > 0) {
        //已登录过
        var login = list[0];
        context.read<GlobalState>().setLoginUser(login);
        log("App has Login:${login.toString()}", name: "HomePage");
      } else {
        context.read<GlobalState>().logout();
      }
    };
    requestPermissions();
    loadSp();
  }

  void refreshData() {}

  void requestPermissions() async {
    await Permission.storage.request();
  }

  void logout() async{
    var dao = UserLoginDao();
    var loginUser = context.read<GlobalState>().loginUser;
    await dao.delete(loginUser);
    context.read<GlobalState>().logout();
  }
}
