import 'package:flutter/material.dart';
import 'package:power_chart/chart/PowerChartData.dart';

import '../paint/borderPaint.dart';
import '../paint/gridPaint.dart';


class BaseLayoutPainter extends CustomPainter {
  final PowerChartData data;
  final BorderPaint borderPaint;
  final GridPaint gridPaint;
  final Paint backgroundPaint;
  final Paint chartPaint;

  const BaseLayoutPainter(this.data, this.borderPaint, this.gridPaint,
      this.backgroundPaint, this.chartPaint);

  @override
  void paint(Canvas canvas, Size size) {
    _drawBorder(canvas, size);
    _drawBackgroundGrid(canvas, size);
    _drawBackground(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return null;
  }

  void _drawBorder(Canvas canvas, Size size) {
    final topLeft = Offset(0, 0);
    final topRight = Offset(size.width, 0);
    final bottomLeft = Offset(0, size.height);
    final bottomRight = Offset(size.width, size.height);

    canvas.drawLine(topLeft, topRight, borderPaint.topLine);
    canvas.drawLine(topRight, bottomRight, borderPaint.rightLine);
    canvas.drawLine(bottomRight, bottomLeft, borderPaint.bottomLine);
    canvas.drawLine(bottomLeft, topLeft, borderPaint.leftLine);
  }

  void _drawBackgroundGrid(Canvas canvas, Size size) {
    _drawVerticalLine(canvas, size);
    _drawHorizontalLine(canvas, size);
  }

  void _drawVerticalLine(Canvas canvas, Size size) {
    for (var i = 0; i < data.pointList.length; i++) {
      canvas.drawLine(
        Offset(data.pointList[i].x, 0),
        Offset(data.pointList[i].x, size.height),
        gridPaint.verticalLinePaint,
      );
    }
  }

  void _drawHorizontalLine(Canvas canvas, Size size) {
    for (var i = 0; i < data.pointList.length; i++) {
      canvas.drawLine(
        Offset(0, data.pointList[i].y),
        Offset(size.width, data.pointList[i].y),
        gridPaint.horizontalLinePaint,
      );
    }
  }

  void _drawBackground(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      backgroundPaint,
    );
  }
}
