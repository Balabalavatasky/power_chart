import 'package:flutter/material.dart';
import 'package:power_chart/chart/PowerChartData.dart';

class LineChartPainter extends CustomPainter {
  final PowerChartData data;
  final Paint chartPaint;


  LineChartPainter(this.data, this.chartPaint,);
  @override
  void paint(Canvas canvas, Size size) {
    _drawLineChart(canvas, size);
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return false;
  }

  void _drawLineChart(Canvas canvas, Size size) {
    double domainDistance = data.maxDomain - data.minDoamin;
    final path = Path()
      ..moveTo(
          (data.pointList.first.x - data.minDoamin) /
              domainDistance *
              size.width,
          (1 - data.pointList.first.y / data.maxRange) * size.height);

    for (var i = 1; i < data.pointList.length; i++) {
      double x = (data.pointList[i].x - data.minDoamin) / domainDistance;
      double y = 1 - data.pointList[i].y / data.maxRange;
      path.lineTo(x * size.width, y * size.height);
    }
    canvas.drawPath(path, chartPaint);
  }


}
