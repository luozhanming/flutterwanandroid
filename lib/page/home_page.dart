import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/styles.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/page/login_page.dart';
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

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: Config.DESIGN_WIDTH);
    return ChangeNotifierProvider<_HomeViewModel>(
      create: (context) => _HomeViewModel(),
      builder: (context,child)=>Scaffold(
        appBar: AppBar(
          leading: UnconstrainedBox(
              //解除限制
              child: OvalWidget(
                  width: 40,
                  height: 40,
                  child: Image.network(
                    "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3002726819,68308266&fm=26&gp=0.jpg",
                    fit: BoxFit.cover,
                  ))),
          title: UnconstrainedBox(
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.black54,
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(3))),
              onTap: () {
                context.read<GlobalState>().setTheme(ThemeData(backgroundColor: Colors.green));
              },
              child: Container(
                width: 320,
                height: 36,
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
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                        child: Icon(Icons.search),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(2)),
                        child: Text(
                          S.of(context).search_website_content,
                          style: TextStyles.titleTextStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar:  Consumer<_HomeViewModel>(
          builder: (context,value,child)=>FFNavigationBar(
              selectedIndex: value.selectedIndex,
              theme: FFNavigationBarTheme(
                  barHeight: ScreenUtil().setWidth(36),
                  itemWidth: ScreenUtil().setWidth(30)),
              items: getNavigationBarItems(),
              onSelectTab: (index) {
                value.changeSelectedIndex(index);
              },
            ),
        ),

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

class _HomeViewModel with ChangeNotifier{
  int selectedIndex;


  _HomeViewModel(){
    selectedIndex = 0;
  }

  void dispose() {}

  void changeSelectedIndex(index) {
    selectedIndex = index;
    notifyListeners();
  }
}
