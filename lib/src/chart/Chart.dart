import 'package:flutter/material.dart';
import 'package:power_chart/src/chart/painter/baseLayoutPainter.dart';
import 'package:power_chart/src/chart/painter/indicatorPainter.dart';
import 'package:power_chart/src/configuration/backgroundGrid.dart';
import 'package:power_chart/src/configuration/chartBorder.dart';
import 'package:power_chart/src/configuration/graph.dart';
import 'package:power_chart/src/configuration/indicator.dart';

class PowerChart extends StatefulWidget {
  final Color backgroundColor;
  final List<Graph> graph;
  final bool showIndicators;
  final Indicator indicator;
  final ChartBorder chartBorder;
  final BackgroundGrid backgroundgrid;

  PowerChart(
    this.graph, {
    Key key,
    this.backgroundColor = Colors.white,
    this.chartBorder,
    this.backgroundgrid,
    this.showIndicators = false,
    this.indicator,
  }) : super(key: key);

  @override
  _PowerChartState createState() => _PowerChartState();
}

class _PowerChartState extends State<PowerChart> {
  List<Graph> graphList;
  Offset touchPoint;
  @override
  void initState() {
    graphList = widget.graph;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final baselayoutpaint = BaseLayoutPainter(graphList,
            showIndicators: widget.showIndicators,
            touchPoint: touchPoint,
            backgroundColor: widget.backgroundColor,
            border: widget.chartBorder,
            backgroundgrid: widget.backgroundgrid);

        final indicatorPaint = IndicatorPainter(
          graphList,
          widget.showIndicators,
          touchPoint,
          widget.backgroundColor,
          widget.chartBorder,
          widget.backgroundgrid,
        );

        return GestureDetector(
          onPanUpdate: (detail) {
            if (widget.showIndicators) {
              setState(() {
                touchPoint = detail.localPosition;
              });
            }
          },
          onPanStart: (detail) {
            if (widget.showIndicators) {
              setState(() {
                touchPoint = detail.localPosition;
              });
            }
          },
          onPanEnd: (detail) {
            if (widget.showIndicators) {
              setState(() {
                touchPoint = null;
              });
            }
          },
          child: CustomPaint(
            size: constraints.biggest,
            foregroundPainter: indicatorPaint,
            child: RepaintBoundary(
              child: CustomPaint(
                size: constraints.biggest,
                painter: baselayoutpaint,
              ),
            ),
          ),
        );
      },
    );
  }
}
