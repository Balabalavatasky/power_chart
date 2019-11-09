import 'package:flutter/material.dart';
import 'package:power_chart/power_chart.dart';

class BaseLayoutPainter extends CustomPainter {
  final Color backgroundColor;
  final ChartBorder border;
  final BackgroundGrid backgroundgrid;

  const BaseLayoutPainter(
      this.backgroundColor, this.border, this.backgroundgrid);

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawBackgroundGrid(canvas, size);
    _drawBorder(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void _drawBackgroundGrid(Canvas canvas, Size size) {
    _drawVerticalLine(canvas, size);
    _drawHorizontalLine(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      Paint()..color = backgroundColor,
    );
  }

  void _drawBorder(Canvas canvas, Size size) {
    _drawAxis(canvas, size);
    _drawAxisIndicator();
  }

  void _drawAxis(Canvas canvas, Size size) {
    final topLeft = Offset(0, 0);
    final topRight = Offset(size.width, 0);
    final bottomLeft = Offset(0, size.height);
    final bottomRight = Offset(size.width, size.height);

    if (border.top != null) {
      canvas.drawLine(topLeft, topRight, border.top.axisPaint);
      _drawScale(canvas, size, border.top);
    }
    if (border.right != null) {
      canvas.drawLine(topRight, bottomRight, border.right.axisPaint);
      _drawScale(canvas, size, border.right);
    }
    if (border.bottom != null) {
      canvas.drawLine(bottomRight, bottomLeft, border.bottom.axisPaint);
      _drawScale(canvas, size, border.bottom);
    }

    if (border.left != null) {
      canvas.drawLine(bottomLeft, topLeft, border.left.axisPaint);
      _drawScale(canvas, size, border.left);
    }
  }

  void _drawAxisIndicator() {}
  void _drawScale(Canvas canvas, Size size, ChartAxis axis) {}

  void _drawVerticalLine(Canvas canvas, Size size) {
    // for (var i = 0; i < data.pointList.length; i++) {
    //   canvas.drawLine(
    //     Offset(data.pointList[i].x, 0),
    //     Offset(data.pointList[i].x, size.height),
    //     gridPaint.verticalLinePaint,
    //   );
    // }
  }

  void _drawHorizontalLine(Canvas canvas, Size size) {
    // for (var i = 0; i < data.pointList.length; i++) {
    //   canvas.drawLine(
    //     Offset(0, data.pointList[i].y),
    //     Offset(size.width, data.pointList[i].y),
    //     gridPaint.horizontalLinePaint,
    //   );
    // }
  }
}
