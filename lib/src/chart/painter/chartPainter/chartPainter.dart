import 'package:flutter/material.dart';
import 'package:power_chart/power_chart.dart';
import 'package:power_chart/src/chart/painter/baseLayoutPainter.dart';

class ChartPainter extends BaseLayoutPainter {
  final List<Graph> graph;
  final Color backgroundColor;
  final ChartBorder border;
  final BackgroundGrid backgroundgrid;

  ChartPainter(this.graph,
      {this.backgroundColor, this.border, this.backgroundgrid})
      : super(backgroundColor, border, backgroundgrid);


  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    _drawChart(canvas, size);
    _drawIndicator(canvas, size);
  }

  @override
  bool shouldRepaint(ChartPainter oldDelegate) {
    return false;
  }

  void _drawChart(Canvas canvas, Size size) {}

  void _drawIndicator(Canvas canvas, Size size) {}
}
