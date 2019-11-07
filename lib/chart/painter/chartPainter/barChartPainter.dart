import 'package:flutter/material.dart';

import 'package:power_chart/chart/PowerChartData.dart';

class BarChartPainter extends CustomPainter {
  final PowerChartData data;
  final Paint chartPaint;
  final bool showIndicators;
  final List<Offset> position;
  final Paint indicatorPaint;
  BarChartPainter(
    this.data,
    this.chartPaint,
    this.showIndicators, {
    this.position,
    this.indicatorPaint,
  }) {
    position.sort((p1, p2) {
      return p1.dy.compareTo(p2.dy);
    });
  }
  @override
  void paint(Canvas canvas, Size size) {
    _drawBarChart(canvas, size);
    _drawIndicator(canvas, size, position);
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) {
    return showIndicators && oldDelegate.position == position;
  }

  void _drawBarChart(Canvas canvas, Size size) {
    double domainDistance = data.maxDomain - data.minDoamin;

    for (var i = 0; i < data.pointList.length; i++) {
      double x = (data.pointList[i].x - data.minDoamin) / domainDistance;
      double y = 1 - data.pointList[i].y / data.maxRange;
      double barWidth = size.width / (data.pointList.length * 2 - 1);
      canvas.drawRRect(
          new RRect.fromLTRBR(
              i == 0
                  ? x * size.width
                  : x * size.width -
                      barWidth / data.pointList.length * i -
                      chartPaint.strokeWidth,
              y * size.height,
              i == 0
                  ? x * size.width + barWidth
                  : x * size.width -
                      barWidth / data.pointList.length * i -
                      chartPaint.strokeWidth +
                      barWidth,
              size.height,
              new Radius.circular(5.0)),
          chartPaint);
    }
  }

  void _drawIndicator(Canvas canvas, Size size, List<Offset> position) {}
}
