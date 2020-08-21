import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/styles.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/widget/my_text_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage,LoginViewModel> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: Config.DESIGN_WIDTH);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).login,
          style: TextStyles.titleTextStyle,
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back,size: ScreenUtil().setWidth(20),),
            onPressed: () {
              exit(0);
            }),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Center(
              child: Card(
                color: Theme.of(context).cardColor,
                elevation: 3.0,
                margin: EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(32)),
                child: Container(
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setWidth(32), ScreenUtil().setWidth(16), ScreenUtil().setWidth(32)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        child: MyTextField(
                            controller: mViewModel._usernameController,
                            hint: S.of(context).hint_input_username,
                            fontSize: 16,
                            icon: Icons.account_circle),
                        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                      ),
                      Container(
                        child: MyTextField(
                          controller:  mViewModel._passwordController,
                          hint: S.of(context).hint_input_password,
                          fontSize: 16,
                          icon: Icons.panorama_vertical,
                          isVisible: false,
                        ),
                        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(100),
                        height: ScreenUtil().setWidth(40),
                        child: FlatButton(
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(10)))),
                          color: Colors.blueAccent,
                          highlightColor: Colors.amber,
                          child: Center(
                            child: Text(
                              S.of(context).login,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  buildViewModel(BuildContext context) {
    return LoginViewModel();
  }
}

class LoginViewModel extends BaseViewModel {
  TextEditingController _usernameController;
  TextEditingController _passwordController;

  @override
  void initState() {
    _usernameController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");

  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }
}
