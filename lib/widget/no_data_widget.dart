

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanandroid/generated/l10n.dart';

class NoDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset("static/images/ic_nodata.png"),
        Padding(padding: EdgeInsets.only(top: ScreenUtil().setWidth(8))),
        Text(S.of(context).no_data)
      ],
    );
  }
}
