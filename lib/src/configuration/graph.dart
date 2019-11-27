import 'package:flutter/material.dart';
import 'package:power_chart/src/chart/PowerChartSeries.dart';
import 'package:power_chart/src/configuration/area.dart';
import 'package:power_chart/src/configuration/enum.dart';
import 'package:power_chart/src/configuration/spot.dart';

class Graph {
  String name;
  PowerChartSeries data;
  Paint chartPaint;
  CHART_TYPE graphType;
  Spot spot;
  Area area;
  bool canDrilldown = false;
  List<Graph> drilldownList = List<Graph>();

  Graph.spline(this.data,
      {this.name, this.chartPaint,  this.spot, this.area})
      : this.graphType = CHART_TYPE.sline;
  Graph.line(this.data,
      {this.name, this.chartPaint,  this.spot, this.area})
      : this.graphType = CHART_TYPE.line;
  Graph.bar(
    this.data, {
    this.name,
    this.chartPaint,

  })  : this.graphType = CHART_TYPE.bar,
        this.area = null,
        this.spot = null;
  Graph.pie(
    this.data, {
    this.name,
    this.chartPaint,

  })  : this.graphType = CHART_TYPE.pie,
        this.area = null,
        this.spot = null;

  Graph drilldown(Graph graph) {
    drilldownList.add(graph);
    canDrilldown = true;
    return this;
  }
}
