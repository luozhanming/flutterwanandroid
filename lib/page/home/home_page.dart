import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/http/HttpManager.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/model/banner.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/page/home/home_segment.dart';
import 'package:wanandroid/page/home/system_segment.dart';
import 'package:wanandroid/widget/circle_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomeViewModel mViewModel;

  @override
  void initState() {
    super.initState();
    mViewModel = _HomeViewModel();
    mViewModel.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: Config.DESIGN_WIDTH);
    return ChangeNotifierProvider<_HomeViewModel>(
      create: (context) => mViewModel,
      builder: (context, child) => Scaffold(
        drawerScrimColor: Colors.transparent,
        drawer: Text("sdfsdfsdfsdfsdfsdfsdfsdf"),
        appBar: PreferredSize(
          preferredSize: Size(ScreenUtil().setWidth(Config.DESIGN_WIDTH),
              ScreenUtil().setWidth(40)),
          child: AppBar(
            leading: Center(),
            flexibleSpace: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Center(
                child: Row(
                  children: <Widget>[
                    Padding(
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(8))),
                    Builder(
                      //将context范围缩到Scaffold
                      builder: (context) => InkWell(
                        onTap: () {
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
                    Padding(
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(8))),
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.black54,
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(3))),
                        onTap: () {
                          context
                              .read<GlobalState>()
                              .setTheme(ThemeData(primaryColor: Colors.green));
                        },
                        child: Container(
                          margin:
                              EdgeInsets.only(right: ScreenUtil().setWidth(8)),
                          height: ScreenUtil().setWidth(26),
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(3))),
                              border: Border.all(color: Colors.black12)),
                          child: Row(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(6)),
                                  child: Icon(Icons.search,
                                      size: ScreenUtil().setWidth(20),
                                      color: context
                                          .select<GlobalState, ThemeData>(
                                              (value) => value.themeData)
                                          .primaryTextTheme
                                          .title
                                          .color),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(4)),
                                  child: Text(
                                    S.of(context).search_website_content,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(14),
                                        color: context
                                            .select<GlobalState, ThemeData>(
                                                (value) => value.themeData)
                                            .primaryTextTheme
                                            .title
                                            .color),
                                  ),
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
          ),
        ),
        bottomNavigationBar: Consumer<_HomeViewModel>(
          builder: (context, value, child) => FFNavigationBar(
            selectedIndex: value.selectedIndex,
            theme: FFNavigationBarTheme(
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
          int selecteIndex = context
              .select<_HomeViewModel, int>((value) => value.selectedIndex);
          if (selecteIndex == 0) {
            return AnimatedSwitcher(
              child: HomeSegment(),
              duration: const Duration(milliseconds: 300),
            );
          } else
            return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: SystemSegment());
        }),
      ),
    );
  }

  List<FFNavigationBarItem> getNavigationBarItems() {
    List<FFNavigationBarItem> items = [];
    items.add(FFNavigationBarItem(
      iconData: Icons.home,
      label: S.of(context).home,
    ));
    items.add(FFNavigationBarItem(
      iconData: Icons.home,
      label: S.of(context).tixi,
    ));
    return items;
  }
}

class _HomeViewModel extends BaseViewModel {
  int selectedIndex;


  void dispose() {
    super.dispose();
  }

  void changeSelectedIndex(index) {
    selectedIndex = index;
    notifyListeners();
  }

  @override
  void initState() {
    selectedIndex = 0;
  }

  void refreshData() {

  }
}
