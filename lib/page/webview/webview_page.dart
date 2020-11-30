import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wanandroid/common/base/base_state.dart';
import 'package:wanandroid/common/base/base_viewmodel.dart';
import 'package:wanandroid/common/styles.dart';
import 'package:wanandroid/model/artical.dart';
import 'package:wanandroid/widget/common_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  static const String NAME = "Webview";

   String url;
   String title;
   int type;


  WebviewPage({@required this.url, this.title,this.type});


  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends BaseState<WebviewPage, WebviewViewModel> {
  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _webViewController = null;
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Builder(builder: (context) {
          return Stack(
            children: <Widget>[
              WebView(
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                  navigationDelegate: (navigation) async {
                    if (navigation.url.startsWith("http") ||
                        navigation.url.startsWith("https")) {
                      return NavigationDecision.navigate;
                    } else {
                      await _launchInBrowser(navigation.url);
                      return NavigationDecision.prevent;
                    }
                  },
                  onPageFinished: (url) {
                    mViewModel.firstLaunch = true;
                  },
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureNavigationEnabled: true),
              Center(
                child: Builder(builder: (context) {
                  bool firstLauch = context.select<WebviewViewModel, bool>(
                      (value) => value.firstLaunch);
                  if (!firstLauch) {
                    return FlareActor(
                      "static/file/bob.flr",
                      animation: "Wave",
                    );
                  } else {
                    return Center();
                  }
                }),
              )
            ],
          );
        }),
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  buildViewModel(BuildContext context) {
    return WebviewViewModel(context);
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return MyAppBar(
      leadingIcon: Icons.close,
      onLeadingIconTap: () {
        Navigator.pop(context);
      },
      widget: Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(16)),
        child: Hero(
          tag: "${widget.title}_${widget.type}",
          child: Text.rich(
            HTML.toTextSpan(context,"<div>${widget.title}</div>",defaultTextStyle: TextStyles.titleTextStyle),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 1,
            style: TextStyles.titleTextStyle,
          ),
        ),
      ),
    );
  }
}

class WebviewViewModel extends BaseViewModel {
  bool _firstLaunch = false;

  WebviewViewModel(BuildContext context) : super(context);

  bool get firstLaunch => _firstLaunch;

  set firstLaunch(bool value) {
    _firstLaunch = value;
    notifyListeners();
  }

  @override
  void initState() {}
}
