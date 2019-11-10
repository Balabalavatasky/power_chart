import 'package:flutter/material.dart';
import 'package:power_chart/power_chart.dart';
import 'package:power_chart/src/chart/painter/baseLayoutPainter.dart';
import 'package:power_chart/src/configuration/indicator.dart';

class IndicatorPainter extends BaseLayoutPainter {
  final List<Graph> graph;
  final bool showIndicators;
  final Offset touchPoint;
  final Indicator indicator;
  final Color backgroundColor;
  final ChartBorder border;
  final BackgroundGrid backgroundgrid;

  IndicatorPainter(this.graph,
      {this.showIndicators = false,
      this.touchPoint,
      this.backgroundColor,
      this.indicator,
      this.border,
      this.backgroundgrid})
      : super(graph,
            showIndicators: showIndicators,
            touchPoint: touchPoint,
            indicator: indicator,
            backgroundColor: backgroundColor,
            border: border,
            backgroundgrid: backgroundgrid);

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    if (showIndicators && touchPoint != null) {
      _drawIndicators(canvas, size);
    }
  }

  @override
  bool shouldRepaint(IndicatorPainter oldDelegate) {
    return showIndicators && oldDelegate.touchPoint == touchPoint;
  }

  void _drawIndicators(Canvas canvas, Size size) {
    final List<Offset> indicatorPositions = List<Offset>();
    for (var spotList in super.spotsList) {
      for (var spot in spotList) {
        if (indicatorPositions.length == 0) {
          if (spot.dx > touchPoint.dx + 10) {
            break;
          } else if ((touchPoint.dx - spot.dx).abs() <= 10) {
            indicatorPositions.add(spot);
            break;
          }
        } else {
          if (indicatorPositions.first.dx > touchPoint.dx) {
            break;
          } else if (indicatorPositions.first.dx == touchPoint.dx) {
            indicatorPositions.add(spot);
            break;
          }
        }
      }
    }
    for (var i = 0; i < indicatorPositions.length; i++) {
      if (indicatorPositions[i] != null) {
        if (i == indicatorPositions.length) {
          canvas.drawLine(indicatorPositions[i],
              Offset(indicatorPositions[i].dx, 0), indicator.indicatorPaint);
        } else {
          canvas.drawLine(
              indicatorPositions[i],
              Offset(indicatorPositions[i].dx, indicatorPositions[i + 1].dy),
              indicator.indicatorPaint);
        }
        canvas.drawCircle(
            indicatorPositions[i], indicator.spotSize, indicator.spotPaint);
      }
    }
  }
}
