import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/common/base/livedata.dart';
import 'package:wanandroid/common/http/http_manager.dart';
import 'package:wanandroid/common/styles.dart';
import 'package:wanandroid/common/util/share_preference.dart';
import 'package:wanandroid/database/db_manager.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/model/resource.dart';
import 'package:wanandroid/model/user.dart';
import 'package:wanandroid/page/home/home_page.dart';
import 'package:wanandroid/repository/user_repository.dart';
import 'package:wanandroid/widget/common_appbar.dart';
import 'package:wanandroid/widget/my_text_field.dart';

class RegistPage extends StatefulWidget {

  static const NAME = "/regist";
  @override
  _RegistPageState createState() => _RegistPageState();
}

class _RegistPageState extends BaseState<RegistPage,_RegistViewModel> {

  @override
  void initState() {
    super.initState();
    mViewModel._state.addListener(() {
      var state = mViewModel._state.value;
      if(state.status==ResourceStatus.empty){
        //对话框消失方式
        Navigator.of(context).popUntil((route) => route.settings.name == RegistPage.NAME);
      }else if(state.status==ResourceStatus.loading){
        showDialog(
            context: context,
            builder: (context) => Center(child: Text("Loading")));
      }else if(state.status==ResourceStatus.success){
        Fluttertoast.showToast(msg: S.of(context).regist_success);
        mViewModel.login();

      }else if(state.status==ResourceStatus.failed){
        Navigator.of(context).popUntil((route) => route.settings.name == RegistPage.NAME);
        Fluttertoast.showToast(msg: state.errorMsg);
      }else if(state.status==ResourceStatus.error){
        Navigator.of(context).popUntil((route) => route.settings.name == RegistPage.NAME);
        Fluttertoast.showToast(msg: S.of(context).regist_failed);
      }
    });
    mViewModel.loginRes.addListener(() {
      var state = mViewModel.loginRes.value.status;
      if(state==ResourceStatus.empty){
        //对话框消失方式
        Navigator.of(context).popUntil((route) => route.settings.name == RegistPage.NAME);
      }else if(state==ResourceStatus.loading){
        showDialog(
            context: context,
            builder: (context) => Center(child: Text("Loading")));
      }else if(state==ResourceStatus.success){
        mViewModel.setAutoLogin(true);
        mViewModel.saveLogin(mViewModel.loginRes.value.data);
        Navigator.of(context).popUntil((route) => route.settings.name == HomePage.NAME);
      }else if(state==ResourceStatus.failed){
        Navigator.of(context).popUntil((route) => route.settings.name == RegistPage.NAME);
        Fluttertoast.showToast(msg: mViewModel.loginRes.value.errorMsg);
      }else if(state==ResourceStatus.error){
        Navigator.of(context).popUntil((route) => route.settings.name == RegistPage.NAME);


      }
    });
  }


  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: _buildContent(context),
      ),
    );
  }

  Stack _buildContent(BuildContext context) {
    return Stack(
        children: <Widget>[
          Hero(
            tag: "back",
            child: Container(
              width: ScreenUtil().setWidth(32),
              height: ScreenUtil().setWidth(32),
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(8),top: ScreenUtil().setWidth(4)+MediaQuery.of(context).padding.top),
              child: Material(
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin:
            EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setWidth(24),
                    horizontal: ScreenUtil().setWidth(12)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Image.asset("static/images/logo.png"),
                    MyTextField(
                      controller: mViewModel._usernameController,
                      icon: Icons.account_circle,
                      fontSize: ScreenUtil().setSp(14.0),
                      hint: S.of(context).hint_input_username,
                    ),
                    MyTextField(
                      controller: mViewModel._passwordController,
                      icon: Icons.account_circle,
                      fontSize: ScreenUtil().setSp(14.0),
                      hint: S.of(context).hint_input_password,
                    ),
                    MyTextField(
                      controller: mViewModel._repasswordController,
                      icon: Icons.account_circle,
                      fontSize: ScreenUtil().setSp(14.0),
                      hint: S.of(context).hint_input_repassword,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setWidth(12)),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(300),
                      height: ScreenUtil().setWidth(30),
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(12),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(30))),
                          color: context.select<GlobalState, Color>(
                                  (value) => value.themeData.primaryColor)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Color.fromARGB(70, 255, 255, 255),
                          onTap: () {
                            mViewModel.confirm();
                          },
                          child: Center(
                            child: Text(S.of(context).sign_up,style: TextStyle(fontSize: ScreenUtil().setWidth(16)),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
  }

  @override
  _RegistViewModel buildViewModel(BuildContext context) {
    return _RegistViewModel(context);
  }


  PreferredSize _buildAppBar(BuildContext context) {
    return MyAppBar(
      leadingIcon: Icons.arrow_back,
      onLeadingIconTap: () => Navigator.pop(context),
      widget: Text(
        S.of(context).sign_up,
        style: TextStyles.titleTextStyle,
      ),
    );
  }
}


enum RegistState{
  IDLE,Loading,Success,Failed
}

class _RegistViewModel extends BaseViewModel{


  TextEditingController _usernameController;
  TextEditingController _passwordController;
  TextEditingController _repasswordController;

  IUserRepository _userRepository;
  CompositeSubscription _subscriptions;

  LiveData<Resource<User>> _state;
  LiveData<Resource<User>> loginRes = LiveData(Resource.empty());


  _RegistViewModel(BuildContext context) : super(context);

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _repasswordController = TextEditingController();
    _userRepository = RemoteUserRepository();
    _subscriptions = CompositeSubscription();
    _state = LiveData(Resource.empty());
  }


  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    _subscriptions.dispose();
    _state.dispose();
    loginRes.dispose();
  }

  void confirm() {
    var username = _usernameController.text;
    var psw = _passwordController.text;
    var repsw = _repasswordController.text;
    _subscriptions.add(_userRepository.register(username, psw, repsw)
    .doOnListen(() {
      _state.value =Resource.loading();
    })
    .listen((event) {
       _state.value = event;
    },onError: (error){
      if(error is NetError){
        _state.value = Resource.failed(error.statusCode,error.message);
      }else{
        _state.value = Resource.error();
      }

    }));
  }


  void setAutoLogin(bool value) async {
    await CommonPreference.getPreference()
        .put(CommonPreference.KEY_AUTO_LOGIN, value);
  }

  /// 保存登录用户信息
  void saveLogin(User data) async {
    var dao = UserLoginDao();
    await dao.insert(data);
    context.read<GlobalState>().setLoginUser(data);
  }

  void login() {
    var username = _usernameController.text;
    var password = _passwordController.text;
    loginRes.value = Resource.loading();
    _userRepository.login(username, password).listen((event) {
      loginRes.value = event;
    }, onError: (error) {
      if(error is NetError){
       loginRes.value = Resource.failed(error.statusCode,error.message);
      }else{
        loginRes.value = Resource.error();
      }
    });
  }

}
