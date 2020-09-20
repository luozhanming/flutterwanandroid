import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/common/base/livedata.dart';
import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/util/share_preference.dart';
import 'package:wanandroid/database/db_manager.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/model/global_state.dart';
import 'package:wanandroid/model/resource.dart';
import 'package:wanandroid/model/user.dart';
import 'package:wanandroid/page/home/home_page.dart';
import 'package:wanandroid/repository/user_repository.dart';
import 'package:wanandroid/widget/my_check_box.dart';
import 'package:wanandroid/widget/my_text_field.dart';

class LoginPage extends StatefulWidget {
  static const NAME = "Login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage, LoginViewModel> {
  @override
  void initState() {
    super.initState();
    mViewModel.loginRes.observe((value) {
      if (value.status == ResourceStatus.success) {
        Fluttertoast.showToast(msg: "登录成功");
        context.read<GlobalState>().setLoginUser(value.data);
        //1.保存用户json到SharePreference
        //2.保存token
        //3.更新状态
        mViewModel.saveLogin(value.data);

        Navigator.of(context)
            .popUntil((route) => route.settings.name == HomePage.NAME);
      } else if (value.status == ResourceStatus.loading) {
        showDialog(
            context: context,
            builder: (context) => Center(child: Text("Loading")));
      } else if (value.status != ResourceStatus.empty) {
        Fluttertoast.showToast(msg: "登录失败");
        //关闭对话框的方式代码
        Navigator.of(context)
            .popUntil((route) => route.settings.name == LoginPage.NAME);
      } else {
        Navigator.of(context)
            .popUntil((route) => route.settings.name == LoginPage.NAME);
      }
    });
  }

  @override
  Widget buildBody(BuildContext context) {
    ScreenUtil.init(context, width: Config.DESIGN_WIDTH);
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(12)),
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
                        fontSize: ScreenUtil().setWidth(12.0),
                        hint: S.of(context).hint_input_username,
                      ),
                      MyTextField(
                        controller: mViewModel._passwordController,
                        icon: Icons.account_circle,
                        fontSize: ScreenUtil().setWidth(12.0),
                        hint: S.of(context).hint_input_password,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: ScreenUtil().setWidth(12)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Builder(builder: (context) {
                            bool isAutoLogin =
                                context.select<LoginViewModel, bool>(
                                    (value) => value.isAutoLogin);
                            return Container(
                              child: MyCheckBox(
                                isChecked: isAutoLogin??false,
                                text: S.of(context).auto_login,
                                onChanged: (value) {
                                  mViewModel.setAutoLogin(value);
                                },
                              ),
                            );
                          }),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(5),
                                    horizontal: ScreenUtil().setWidth(10)),
                                child: Text(S.of(context).register_new_user),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
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
                              mViewModel.login();
                            },
                            child: Center(
                              child: Text(S.of(context).login),
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
        ),
      ),
    );
  }

  @override
  buildViewModel(BuildContext context) {
    return LoginViewModel(context);
  }
}

class LoginViewModel extends BaseViewModel {
  TextEditingController _usernameController;
  TextEditingController _passwordController;

  IUserRepository _userRepository;

  bool isAutoLogin = false;

  LiveData<Resource<User>> loginRes = LiveData(Resource.empty());

  LoginViewModel(BuildContext context) : super(context);

  @override
  void initState() {
    _usernameController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _userRepository = RemoteUserRepository();
    var getAutoLogin = () async {
      isAutoLogin = await CommonPreference.getPreference()
          .get(CommonPreference.KEY_AUTO_LOGIN, false);
      notifyListeners();
    };
    getAutoLogin();
  }

  void login() {
    var username = _usernameController.text;
    var password = _passwordController.text;
    loginRes.value = Resource.loading();
    _userRepository.login(username, password).listen((event) {
      loginRes.value = event;
    }, onError: (error) {
      loginRes.value = Resource.failed();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  void setAutoLogin(bool value) async {
    await CommonPreference.getPreference()
        .put(CommonPreference.KEY_AUTO_LOGIN, value);
    isAutoLogin = value;
    notifyListeners();
  }

  /**
   * 保存登录用户信息
   * */
  void saveLogin(User data) async {
    var dao = UserLoginDao();
    await dao.insert(data);
    context.read<GlobalState>().setLoginUser(data);
  }
}
