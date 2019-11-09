import 'package:flutter/material.dart';

class Indicator {
  final Paint indicatorPaint;
  final List<Offset> position;
  final Paint spotPaint;
  final double spotSize;

  Indicator(this.indicatorPaint, this.position, this.spotPaint, this.spotSize);
}
