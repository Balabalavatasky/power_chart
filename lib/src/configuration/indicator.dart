import 'package:flutter/material.dart';
import 'package:power_chart/src/configuration/spot.dart';

class Indicator {
  final Paint indicatorPaint;
  final Spot spot;
  final Offset position;
  final String name;
  final String value;

  TextPainter _nameTextPainter;

  Indicator({
    this.indicatorPaint,
    this.spot,
    this.position,
    this.name = "",
    this.value = "",
  }) {
    String text = name + " : " + value;
    _nameTextPainter = TextPainter(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
          ),
          text: text,
        ),
        textDirection: TextDirection.ltr)
      ..layout();
  }

  TextPainter get nameTextPainter => _nameTextPainter;
}
