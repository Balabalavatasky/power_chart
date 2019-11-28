import 'package:flutter/material.dart';
import 'package:power_chart/src/configuration/configuration.dart';

abstract class ChartTheme {
  Paint get axisPaint;
  Paint get indicatorPaint;
  Paint get verticalGridLinePaint;
  Paint get horizontalGridLinePaint;
  Paint get linechartPaint;
  Paint get barchartPaint;
  Spot get spot;
  Area get area;
  TextStyle get scaleStyle;
}

class DefaultTheme extends ChartTheme {
  Paint get axisPaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..color = Colors.black;
  Paint get indicatorPaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = linechartPaint.color;
  TextStyle get scaleStyle => TextStyle(
        color: Colors.black,
      );
  Paint get horizontalGridLinePaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Colors.blueGrey;
  Paint get verticalGridLinePaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Colors.blueGrey;
  Paint get linechartPaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = Colors.blueGrey;
  Paint get barchartPaint => Paint()..style = PaintingStyle.fill;
  Spot get spot => Spot(showSpots: false);
  Area get area => Area(showArea: false, color: Colors.blueAccent, opacity: 1);
}
