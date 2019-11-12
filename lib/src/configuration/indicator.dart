import 'package:flutter/material.dart';

class Indicator {
  final Paint indicatorPaint;
  final Paint spotPaint;
  final double spotSize;
  final Offset position;
  final String name;
  final String value;
  final bool showSpot;
  TextPainter _nameTextPainter;

  Indicator({
    this.indicatorPaint,
    this.spotPaint,
    this.spotSize = 5,
    this.position,
    this.showSpot,
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
