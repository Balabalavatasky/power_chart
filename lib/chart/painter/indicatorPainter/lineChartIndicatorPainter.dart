import 'package:flutter/material.dart';

class LineChartIndicatorPainter extends CustomPainter {
  final List<Offset> position;
  final Paint indicatorPaint;
  final Paint spotPaint;
  final double spotSize;

  LineChartIndicatorPainter(
      this.position, this.indicatorPaint, this.spotPaint, this.spotSize);

  @override
  void paint(Canvas canvas, Size size) {
    {
      canvas.drawLine(
          position.last, Offset(position.last.dx, 0), indicatorPaint);
      position.forEach((p) {
        canvas.drawCircle(p, spotSize, spotPaint);
      });
    }
  }

  @override
  bool shouldRepaint(LineChartIndicatorPainter oldDelegate) {
    return oldDelegate.position == position;
  }
}
