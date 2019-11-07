import 'package:flutter/material.dart';
import 'package:power_chart/chart/PowerChartData.dart';

class PieChartPainter extends CustomPainter {
  final PowerChartData data;
  final Paint chartPaint;
  final bool showIndicators;
  final Paint indicatorPaint;
  PieChartPainter(
    this.data,
    this.chartPaint,
    this.showIndicators, {
    this.indicatorPaint,
  }) {}
  @override
  void paint(Canvas canvas, Size size) {
    _drawPieChart(canvas, size);
    _drawIndicator(canvas, size);
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    return showIndicators;
  }

  void _drawPieChart(Canvas canvas, Size size) {}

  void _drawIndicator(Canvas canvas, Size size) {}
}
