import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/common/styles.dart';
import 'package:wanandroid/generated/l10n.dart';
import 'package:wanandroid/widget/my_text_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoginState {
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
              Navigator.of(context).pop();
            }),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Container(),
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
                            controller: _usernameController,
                            hint: S.of(context).hint_input_username,
                            fontSize: 16,
                            icon: Icons.account_circle),
                        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                      ),
                      Container(
                        child: MyTextField(
                          controller: _passwordController,
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
