import 'package:flutter/material.dart';
import 'package:power_chart/src/chart/PowerChartData.dart';
import 'package:power_chart/src/configuration/enum.dart';
import 'package:power_chart/src/configuration/indicator.dart';

class Graph {
  final PowerChartData data;
  final Paint chartPaint;
  final bool showIndicators;
  final Indicator indicators;
  final CHART_TYPE graphType;

  Graph.sLine(this.data,
      {this.chartPaint, this.showIndicators, this.indicators})
      : this.graphType = CHART_TYPE.sline;
  Graph.line(this.data, {this.chartPaint, this.showIndicators, this.indicators})
      : this.graphType = CHART_TYPE.line;
  Graph.bar(this.data, {this.chartPaint, this.showIndicators, this.indicators})
      : this.graphType = CHART_TYPE.bar;
  Graph.pie(this.data, {this.chartPaint, this.showIndicators, this.indicators})
      : this.graphType = CHART_TYPE.pie;
}
