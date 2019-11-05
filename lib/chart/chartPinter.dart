import 'dart:math';

import 'package:flutter/material.dart';

import 'PowerSparkData.dart';


class ChartPainter extends CustomPainter {
  final PowerChartData data;
  final String type;
  final Paint chartPaint;

  const ChartPainter.smoothlineChart(this.data, this.chartPaint)
      : type = "smoothlineChart";

  const ChartPainter.lineChart(this.data, this.chartPaint) : type = "lineChart";

  const ChartPainter.barChart(this.data, this.chartPaint) : type = "barChart";

  const ChartPainter.pieChart(this.data, this.chartPaint) : type = "pieChart";

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case "smoothlineChart":
        _drawSmoothlineChart(canvas, size);
        break;
      case "lineChart":
        _drawLineChart(canvas, size);
        break;
      case "barChart":
        _drawBarChart(canvas, size);
        break;
      case "pieChart":
        _drawPieChart(canvas, size);
        break;
      default:
        _drawLineChart(canvas, size);
        break;
    }
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

      Point controllerPoint1 = Point((nextx + x) * 0.5, y);
      Point controllerPoint2 = Point((nextx + x) * 0.5, nexty);

      path.cubicTo(controllerPoint1.x, controllerPoint1.y, controllerPoint2.x,
          controllerPoint2.y, nextx, nexty);
    }
    canvas.drawPath(path, chartPaint);
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

  void _drawPieChart(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
