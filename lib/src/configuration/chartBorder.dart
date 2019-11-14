import 'package:flutter/material.dart';
import 'package:power_chart/src/configuration/chartAxis.dart';

class ChartBorder {
  final bool showHorizontalAxis;
  final bool showVerticalAxis;
  final ChartAxis horizontalAxis;
  final ChartAxis verticalAxis;
  final Paint horizontalAxisPaint;
  final Paint verticalAxisPaint;

  ChartBorder({
    this.showHorizontalAxis,
    this.showVerticalAxis,
    this.horizontalAxis,
    this.verticalAxis,
    this.horizontalAxisPaint,
    this.verticalAxisPaint,
  });
}
