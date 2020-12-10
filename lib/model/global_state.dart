import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/common/base/event_bus.dart';
import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/event.dart';
import 'package:wanandroid/common/http/http_manager.dart';
import 'package:wanandroid/model/user.dart';

class GlobalState with ChangeNotifier {

  GlobalState();

  ThemeData themeData = ThemeData(
    primaryColor: Colors.yellow,
  );

  User loginUser = null;

  bool isLogin = false;

  Locale locale = Locale("zh", "CN");

  void setLoginUser(User user) {
    if (user != loginUser) {
      loginUser = user;
      isLogin = true;
    }
    notifyListeners();
  }


  void logout(){
    loginUser = null;
    isLogin = false;
    //清理cookie
    Bus.getEventBus().fire(Logout());
    notifyListeners();
  }

  void setLocal(Locale locale){
    this.locale = locale;
    notifyListeners();
  }


  void setTheme(ThemeData data){
    if(data!= themeData){
      themeData = data;
    }
    notifyListeners();
  }

  void addCollect(int id){
    if(loginUser!=null){
      loginUser.collectIds.add(id);
      notifyListeners();
    }
  }

  void removeCollect(int id){
    if(loginUser!=null){
      loginUser.collectIds.remove(id);
      notifyListeners();
    }
  }
}
