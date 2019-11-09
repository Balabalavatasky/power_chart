import 'package:flutter/material.dart';
import 'package:power_chart/src/chart/painter/chartPainter.dart';
import 'package:power_chart/src/configuration/backgroundGrid.dart';
import 'package:power_chart/src/configuration/graph.dart';

class PowerChart extends StatefulWidget {
  final Color backgroundColor;
  final List<Graph> graph;
  final Border border;
  final BackgroundGrid backgroundgrid;

  PowerChart(
    this.graph, {
    Key key,
    this.backgroundColor,
    this.border,
    this.backgroundgrid,
  }) : super(key: key);

  @override
  _PowerChartState createState() => _PowerChartState();
}

class _PowerChartState extends State<PowerChart> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          child: CustomPaint(
            size: constraints.biggest,
            painter: ChartPainter(widget.graph),
          ),
        );
      },
    );
  }
}
