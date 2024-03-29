import 'package:flutter/widgets.dart';

class ProgressBar extends StatefulWidget {
  final int max;
  final int progress;
  final Color backgroundColor;
  final Color progressColor;
  final double radius;
  final Size size;

  const ProgressBar(
      {this.max = 100,
      this.progress = 0,
      this.backgroundColor,
      this.progressColor,
      this.size,
      this.radius = 0});

  @override
  State<StatefulWidget> createState() {
    return _ProgressbarState();
  }
}

class _ProgressbarState extends State<ProgressBar> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.size.width,
        height: widget.size.height,
        child: CustomPaint(
          size: widget.size,
          painter: PrgressBarPainter(
              max: widget.max,
              progress: widget.progress,
              backgroundColor: widget.backgroundColor,
              progressColor: widget.progressColor,
              radius: widget.radius),
        ));
  }

  @override
  void didUpdateWidget(covariant ProgressBar oldWidget) {
    if (oldWidget.progress != widget.progress) {
      var oldValue = oldWidget.progress;
      var newValue = widget.progress;
      final AnimationController controller = new AnimationController(duration:Duration(seconds: 2),vsync: this);
      
    }
  }
}

class PrgressBarPainter extends CustomPainter {
  final int max;
  final int progress;
  final Color backgroundColor;
  final Color progressColor;
  final double radius;
  Paint drawPaint;

  PrgressBarPainter(
      {this.max,
      this.progress,
      this.backgroundColor,
      this.progressColor,
      this.radius = 0})
      : drawPaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;
    drawPaint
      ..style = PaintingStyle.fill
      ..color = backgroundColor;
    var rect1 =
        RRect.fromRectXY(Rect.fromLTWH(0, 0, width, height), radius, radius);
    canvas.drawRRect(rect1, drawPaint);
    drawPaint
      ..style = PaintingStyle.fill
      ..color = progressColor;
    var progressWidth = (progress.toDouble() / max) * width;
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, progressWidth, height),
            Radius.circular(radius)),
        drawPaint);
  }

  @override
  bool shouldRepaint(PrgressBarPainter oldDelegate) {
    return max != oldDelegate.max || progress != oldDelegate.progress;
  }
}
