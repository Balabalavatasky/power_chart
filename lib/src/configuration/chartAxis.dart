import 'package:flutter/material.dart';

class ChartAxis {
  final bool showScale;
  final bool autoScale;
  final bool showScaleIndicator;
  final int interval;
  final int scaleCount;
  final Paint axisPaint;
  final Paint indicatorPaint;
  final TextStyle scaleStyle;
  ChartAxis({
    this.showScale = false,
    this.autoScale = true,
    this.showScaleIndicator = false,
    this.interval = 1,
    this.scaleCount,
    this.axisPaint,
    this.indicatorPaint,
    this.scaleStyle,
  });
}
