import 'package:flutter/material.dart';
import 'package:power_chart/src/configuration/chartAxis.dart';

class ChartBorder {
  final ChartAxis horizontalAxis;
  final ChartAxis verticalAxis;
  final Paint top;
  final Paint left;
  final Paint bottom;
  final Paint right;

  ChartBorder(
      {this.horizontalAxis,
      this.verticalAxis,
      this.top,
      this.left,
      this.bottom,
      this.right});
}
