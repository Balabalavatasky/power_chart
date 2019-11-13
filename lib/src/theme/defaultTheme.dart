import 'package:flutter/material.dart';
import 'package:power_chart/src/configuration/spot.dart';

abstract class ChartTheme {
  Paint get axisPaint;
  Paint get indicatorPaint;
  Paint get verticalGridLinePaint;
  Paint get horizontalGridLinePaint;
  Paint get linechartPaint;
  Spot get spot;
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
    ..color = Colors.black;
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
  Spot get spot => Spot(showSpots: false);
}
