import 'package:flutter/material.dart';
import 'package:power_chart/src/configuration/chartAxis.dart';

class ChartBorder {
  final ChartAxis horizontalAxis;
  final ChartAxis verticalAxis;
  final bool showTop;
  final bool showLeft;
  final bool showBootom;
  final bool showRight;
  final Paint top;
  final Paint left;
  final Paint bottom;
  final Paint right;

  ChartBorder({
    this.horizontalAxis,
    this.verticalAxis,
    this.top,
    this.left,
    this.bottom,
    this.right,
    this.showTop = false,
    this.showLeft = false,
    this.showBootom = false,
    this.showRight = false,
  });
}
