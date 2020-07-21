import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/page/home/home_page.dart';
import 'package:wanandroid/page/search/search_page.dart';

import 'package:wanandroid/redux/app_redux.dart';

import 'package:battery/battery.dart';


final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
class FlutterReduxApp extends StatefulWidget {
  @override
  _FlutterReduxAppState createState() => _FlutterReduxAppState();
}

class _FlutterReduxAppState extends State<FlutterReduxApp> {
  final Store store = Store<AppState>(appReducer);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale("zh", "CN"),
        //   ...S.delegate.supportedLocales
      ],
      locale: context.select<GlobalState, Locale>((value) => value.locale),
      theme: context.select<GlobalState, ThemeData>((value) => value.themeData),
      routes: {
        HomePage.NAME: (context) {
          return HomePage();
        },
        SearchPage.NAME: (context) {
          return SearchPage();
        }
      },
      navigatorObservers:[routeObserver] ,
    );
  }
}
