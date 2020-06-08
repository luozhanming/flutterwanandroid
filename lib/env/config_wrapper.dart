import 'package:flutter/material.dart';

class ConfigWrapper extends StatefulWidget {
  final Widget child;

  ConfigWrapper({Key key, this.child});

  @override
  _ConfigWrapperState createState() => _ConfigWrapperState();
}

class _ConfigWrapperState extends State<ConfigWrapper> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _InheritedConfig extends InheritedWidget {
  const _InheritedConfig({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    throw UnimplementedError();
  }
}
