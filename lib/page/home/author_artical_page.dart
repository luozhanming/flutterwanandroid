import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/common/config/config.dart';
import 'package:wanandroid/widget/common_appbar.dart';

class AuthorArticalPage extends StatefulWidget {
  static const NAME = "AuthorArticals";

  final String authorName;

  const AuthorArticalPage({this.authorName}) : assert(authorName != null);

  @override
  _AuthorArticalPageState createState() => _AuthorArticalPageState();
}

class _AuthorArticalPageState
    extends BaseState<AuthorArticalPage, AuthorArticalViewModel> {
  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(ScreenUtil().setWidth(Config.DESIGN_WIDTH),
            ScreenUtil().setWidth(40)),
        child: _buildAppBar(context),
      ),
    );
  }

  @override
  AuthorArticalViewModel buildViewModel(BuildContext context) {
    return AuthorArticalViewModel(context);
  }

  _buildAppBar(BuildContext context) {
    return MyAppBar(
      leadingIcon: Icons.arrow_back,
      onLeadingIconTap: () => Navigator.pop(context),
      widget: Container(
        child: Text(widget.authorName),
      ),
    );
  }
}

class AuthorArticalViewModel extends BaseViewModel {
  AuthorArticalViewModel(BuildContext context) : super(context);

  @override
  void initState() {
    // TODO: implement initState
  }
}
