import 'package:flutter/material.dart';

import 'package:power_chart/chart/PowerChartData.dart';

class SmoothlineChartPainter extends CustomPainter {
  final PowerChartData data;
  final Paint chartPaint;

  SmoothlineChartPainter(this.data, this.chartPaint);

  @override
  void paint(Canvas canvas, Size size) {
    _drawSmoothlineChart(canvas, size);
  }

  @override
  bool shouldRepaint(SmoothlineChartPainter oldDelegate) {
    return false;
  }

  void _drawSmoothlineChart(Canvas canvas, Size size) {
    double domainDistance = data.maxDomain - data.minDoamin;

    final path = new Path()
      ..moveTo(
          (data.pointList.first.x - data.minDoamin) /
              domainDistance *
              size.width,
          (1 - data.pointList.first.y / data.maxRange) * size.height);

    for (int i = 0; i < data.pointList.length - 1; i++) {
      double x =
          (data.pointList[i].x - data.minDoamin) / domainDistance * size.width;
      double y = (1 - data.pointList[i].y / data.maxRange) * size.height;

      double nextx = (data.pointList[i + 1].x - data.minDoamin) /
          domainDistance *
          size.width;
      double nexty =
          (1 - data.pointList[i + 1].y / data.maxRange) * size.height;

      path.moveTo(x, y);

      Offset controllerPoint1 = Offset((nextx + x) * 0.5, y);
      Offset controllerPoint2 = Offset((nextx + x) * 0.5, nexty);

      path.cubicTo(controllerPoint1.dx, controllerPoint1.dy,
          controllerPoint2.dx, controllerPoint2.dy, nextx, nexty);
    }
    canvas.drawPath(path, chartPaint);
  }
}
