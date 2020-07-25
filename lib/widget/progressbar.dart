

import 'package:flutter/widgets.dart';

class ProgressBar extends StatelessWidget{


  final int max;
  final int progress;
  final Color backgroundColor;
  final Color progressColor;
  final double height;


  ProgressBar({this.max, this.progress, this.backgroundColor, this.progressColor,
      this.height});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(

    );
  }

}


class PrgressBarPainter extends CustomPainter{


  final int max;
  final int progress;
  final Color backgroundColor;
  final Color progressColor;
  final double height;


  @override
  void paint(Canvas canvas, Size size) {
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    throw UnimplementedError();
  }

}