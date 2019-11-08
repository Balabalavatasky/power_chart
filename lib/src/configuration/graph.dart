import 'package:flutter/material.dart';
import 'package:power_chart/src/chart/PowerChartData.dart';

class Graph {
  final PowerChartData data;
  final Paint chartPaint;
  final bool showIndicators;
  final Paint indicatorPaint;
  final String graphType;

  Graph.sLine(this.data,
      {this.chartPaint, this.showIndicators, this.indicatorPaint})
      : this.graphType = "sLine";
  Graph.line(this.data,
      {this.chartPaint, this.showIndicators, this.indicatorPaint})
      : this.graphType = "line";
  Graph.bar(this.data,
      {this.chartPaint, this.showIndicators, this.indicatorPaint})
      : this.graphType = "bar";
  Graph.pie(this.data,
      {this.chartPaint, this.showIndicators, this.indicatorPaint})
      : this.graphType = "pie";
}
