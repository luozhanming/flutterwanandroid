import 'package:redux/redux.dart';
import 'package:wanandroid/model/user.dart';


//用于绑定State和Action
final UserRedux = combineReducers<User>([
  TypedReducer<User,UpdateUserAction>(_updateLoaded),
]);


///定一个 UpdateUserAction ，用于发起 userInfo 的的改变
///类名随你喜欢定义，只要通过上面TypedReducer绑定就好
class UpdateUserAction {
  final User userInfo;

  UpdateUserAction(this.userInfo);
}



class FetchUserAction{}
User _updateLoaded(User state, UpdateUserAction action) {
}
