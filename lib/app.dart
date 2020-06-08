
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:wanandroid/common/router/routes_util.dart';
import 'package:wanandroid/redux/app_redux.dart';

class FlutterReduxApp extends StatefulWidget {
  @override
  _FlutterReduxAppState createState() => _FlutterReduxAppState();
}

class _FlutterReduxAppState extends State<FlutterReduxApp> {

  final Store store = Store<AppState>(appReducer);


  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
        child: StoreBuilder(
        builder: (BuildContext context,Store store){
          return MaterialApp(
            onGenerateRoute: Routes.getInstance().getRouter().generator,
          );
        },
      ),
    );
  }
}
