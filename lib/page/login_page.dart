import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanandroid/widget/my_text_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoginState {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1280);
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(600),
                    child: MyTextField(
                        controller: _usernameController,
                        hint: "请输入用户名",
                        icon: Icons.account_circle),
                    margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(600),
                    child: MyTextField(
                      controller: _passwordController,
                      hint: "请输入密码",
                      icon: Icons.panorama_vertical,
                      isVisible: false,
                    ),
                    margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setWidth(60),
                    child: FlatButton(
                      onPressed: (){},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(10)))),
                      color: Colors.blueAccent,
                      highlightColor: Colors.amber,
                      child: Center(
                        child: Text("登录"),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

mixin LoginState on State<LoginPage> {
  TextEditingController _usernameController;
  TextEditingController _passwordController;

  @override
  void initState() {
    _usernameController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }
}
