

import 'package:flutter/cupertino.dart';

abstract class BaseViewModel with ChangeNotifier{
  //空闲状态
  static const int STATE_IDEL = 1001;
  //刷新状态
  static const int STATE_REFRESH = 1002;
  //加载更多状态
  static const int STATE_LOADMORE = 1003;
  //加载成功状态
  static const int STATE_SUCCESS = 1004;
  //加载失败状态
  static const int STATE_FAILED = 1005;
  //没有更多数据状态
  static const int STATE_NOMORE = 1006;

  DataState _state = DataState.idel;


  DataState get state => _state;


  BuildContext _context;

  BuildContext get context =>_context;

  BaseViewModel(BuildContext context){
    _context = context;
  }

  set state(DataState value) {
    _state = value;
  }

  void initState();

  void dispose(){
    super.dispose();
    _context = null;
  }


}

enum DataState{
  idel,
  loading,
  refresh,
  loadmore,
  success,
  failed,
  nomore
}