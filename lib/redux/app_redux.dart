import 'package:wanandroid/model/user.dart';
import 'package:wanandroid/redux/user_redux.dart';

class AppState {
  User user;

  AppState({this.user});
}

//Reducer就是一个方法，传入
AppState appReducer(AppState state, action) {
  return AppState(
    user:UserRedux(state.user,action)
  );
}