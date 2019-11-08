import 'package:flutter/material.dart';

class ChartAxis {
  final bool showScale;
  final int space;
  final Paint axisPaint;
  final Paint indicatorPaint;
  ChartAxis(
      {this.showScale = false,
      this.space = 1,
      this.axisPaint,
      this.indicatorPaint});
}
