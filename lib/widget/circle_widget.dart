import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OvalWidget extends StatelessWidget {
  final Widget child;

  final double borderWidth;

  final Color boarderColor;

  final double width;

  final double height;

  const OvalWidget(
      {this.child,
      this.borderWidth = 2,
      this.boarderColor = Colors.white,
      @required this.width,
      @required this.height})
      : assert(borderWidth < width / 2);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: this.width,
        height: this.height,
        color: boarderColor,
        child: Padding(
          padding: EdgeInsets.all(borderWidth),
          child: ClipOval(
            child: child,
          ),
        ),
      ),
    );
  }
}
