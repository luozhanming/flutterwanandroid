import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid/database/db_manager.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/repository/collect_repository.dart';

///dart单例写法
class CollectionHelper {
  static final CollectionHelper _helper = CollectionHelper._();

  ICollectionsRepository _repository;

  UserLoginDao _userLoginDao ;

  CollectionHelper._() {
    _repository = RemoteCollectionsRepository();
    _userLoginDao = UserLoginDao();
  }

  factory CollectionHelper.getHelper() => _helper;


  ///收藏
  void collect(
      BuildContext context, Artical artical, [CollectResultCallback callback]) {
    _repository.collectArtical(artical).listen((event) {
      if (event) {
        GlobalState state = context.read<GlobalState>();
        state.addCollect(artical.id);
        var user = state.loginUser;
        _userLoginDao.update(user);

      }
      callback.call(event);
    }, onError: (error) {
      callback.call(false);
    });
  }


  ///取消收藏
  void uncollect(
      BuildContext context, Artical artical, [CollectResultCallback callback]) {
    _repository.uncollectArtical(artical).listen((event) {
      if (event) {
        GlobalState state = context.read<GlobalState>();
        state.removeCollect(artical.id);
        var user = state.loginUser;
        _userLoginDao.update(user);
      }
      callback.call(event);
    }, onError: (error) {
      callback.call(false);
    });
  }
}

typedef CollectResultCallback = Function(bool success);
