import 'package:flutter/material.dart';

class ChartAxis {
  bool showScale;
  bool autoScale;
  bool showScaleIndicator;
  int interval;
  int scaleCount;
  Paint axisPaint;
  Paint indicatorPaint;
  TextStyle scaleStyle;
  ChartAxis({
    this.showScale = false,
    this.autoScale = true,
    this.showScaleIndicator = false,
    this.interval = 1,
    this.scaleCount = 5,
    this.axisPaint,
    this.indicatorPaint,
    this.scaleStyle,
  });
}
