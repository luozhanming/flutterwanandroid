import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanandroid/common/base/event_bus.dart';
import 'package:wanandroid/common/http/http_manager.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/page/home/author_artical_page.dart';
import 'package:wanandroid/page/home/home_page.dart';
import 'package:wanandroid/page/login/login_page.dart';
import 'package:wanandroid/page/login/regist_page.dart';
import 'package:wanandroid/page/mycollection_page.dart';
import 'package:wanandroid/page/search/search_page.dart';
import 'package:wanandroid/page/webview/webview_page.dart';

import 'common/config/config.dart';
import 'common/event.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class FlutterReduxApp extends StatefulWidget {
  @override
  _FlutterReduxAppState createState() => _FlutterReduxAppState();
}

class _FlutterReduxAppState extends State<FlutterReduxApp> {
  @override
  void initState() {
    super.initState();
    //监听登出
    Bus.getEventBus()
        .streamController
        .stream
        .where((event) => event is Logout)
        .listen((event) {
      HttpManager.getManager(Config.ENV.baseUrl)
          .getCookieJar()
          .delete(Uri.parse(Config.ENV.baseUrl), true);
    });

  }

  @override
  Widget build(BuildContext context) {
    var themeData =
        context.select<GlobalState, ThemeData>((value) => value.themeData);
    var locale = context.select<GlobalState, Locale>((value) => value.locale);
    return RefreshConfiguration(
      hideFooterWhenNotFull: true,
      child: MaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [
          const Locale("zh", "CN"),
          ...S.delegate.supportedLocales
        ],
        locale: locale,
        theme: themeData,
        routes: {
          HomePage.NAME: (context) {
            return HomePage();
          },
          LoginPage.NAME: (context) {
            return LoginPage();
          },
          SearchPage.NAME: (context) {
            return SearchPage();
          },
          WebviewPage.NAME: (context) {
            return WebviewPage();
          },
          AuthorArticalPage.NAME:(context){
            return AuthorArticalPage();
          },
          MyCollectionPage.NAME:(context){
            bool isLogin = context.select<GlobalState,bool>((value) => value.isLogin);
            if(isLogin){
              return MyCollectionPage();
            }else{
              return LoginPage();
            }
          },
          RegistPage.NAME:(context){
            return RegistPage();
          }
        },
        navigatorObservers: [routeObserver],
      ),
    );
  }
}
