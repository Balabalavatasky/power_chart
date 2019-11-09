import 'package:flutter/material.dart';
import 'package:power_chart/power_chart.dart';
import 'package:power_chart/src/chart/painter/baseLayoutPainter.dart';
import 'package:power_chart/src/configuration/enum.dart';
import 'package:power_chart/src/configuration/indicator.dart';

class ChartPainter extends BaseLayoutPainter {
  final List<Graph> graph;
  final Color backgroundColor;
  final ChartBorder border;
  final BackgroundGrid backgroundgrid;

  ChartPainter(this.graph,
      {this.backgroundColor, this.border, this.backgroundgrid})
      : super(backgroundColor, border, backgroundgrid);

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    _drawChart(canvas, size, graph);
  }

  @override
  bool shouldRepaint(ChartPainter oldDelegate) {
    return oldDelegate.graph == graph;
  }

  void _drawChart(Canvas canvas, Size size, List<Graph> graphList) {
    for (var graph in graphList) {
      switch (graph.graphType) {
        case CHART_TYPE.sline:
          _drawSmoothlineChart(canvas, size, graph);
          break;
        case CHART_TYPE.pie:
          _drawPieChart(canvas, size, graph);
          break;
        case CHART_TYPE.line:
          _drawLineChart(canvas, size, graph);
          break;
        case CHART_TYPE.bar:
          _drawBarChart(canvas, size, graph);
          break;
      }
      if (graph.showIndicators) {
        _drawIndicator(canvas, size, graph.indicators);
      }
    }
  }

  void _drawIndicator(Canvas canvas, Size size, Indicator indicator) {
    final List<Offset> position = indicator.position;
    final Paint indicatorPaint = indicator.indicatorPaint;
    final Paint spotPaint = indicator.spotPaint;
    final double spotSize = indicator.spotSize;
    canvas.drawLine(position.last, Offset(position.last.dx, 0), indicatorPaint);
    position.forEach((p) {
      canvas.drawCircle(p, spotSize, spotPaint);
    });
  }

  void _drawSmoothlineChart(Canvas canvas, Size size, Graph graph) {
    final data = graph.data;
    final chartPaint = graph.chartPaint;
    final domainDistance = data.maxDomain - data.minDoamin;
    final path = new Path()
      ..moveTo(
          (data.pointList.first.x - data.minDoamin) /
              domainDistance *
              size.width,
          (1 - data.pointList.first.y / data.maxRange) * size.height);

    for (int i = 0; i < data.pointList.length - 1; i++) {
      double x =
          (data.pointList[i].x - data.minDoamin) / domainDistance * size.width;
      double y = (1 - data.pointList[i].y / data.maxRange) * size.height;

      double nextx = (data.pointList[i + 1].x - data.minDoamin) /
          domainDistance *
          size.width;
      double nexty =
          (1 - data.pointList[i + 1].y / data.maxRange) * size.height;

      path.moveTo(x, y);

      Offset controllerPoint1 = Offset((nextx + x) * 0.5, y);
      Offset controllerPoint2 = Offset((nextx + x) * 0.5, nexty);

      path.cubicTo(controllerPoint1.dx, controllerPoint1.dy,
          controllerPoint2.dx, controllerPoint2.dy, nextx, nexty);
    }
    canvas.drawPath(path, chartPaint);
  }

  void _drawPieChart(Canvas canvas, Size size, Graph graph) {}

  void _drawLineChart(Canvas canvas, Size size, Graph graph) {
    final data = graph.data;
    final chartPaint = graph.chartPaint;
    final double domainDistance = data.maxDomain - data.minDoamin;
    final path = Path()
      ..moveTo(
          (data.pointList.first.x - data.minDoamin) /
              domainDistance *
              size.width,
          (1 - data.pointList.first.y / data.maxRange) * size.height);

    for (var i = 1; i < data.pointList.length; i++) {
      double x = (data.pointList[i].x - data.minDoamin) / domainDistance;
      double y = 1 - data.pointList[i].y / data.maxRange;
      path.lineTo(x * size.width, y * size.height);
    }
    canvas.drawPath(path, chartPaint);
  }

  void _drawBarChart(Canvas canvas, Size size, Graph graph) {
    final data = graph.data;
    final chartPaint = graph.chartPaint;
    final double domainDistance = data.maxDomain - data.minDoamin;

    for (var i = 0; i < data.pointList.length; i++) {
      double x = (data.pointList[i].x - data.minDoamin) / domainDistance;
      double y = 1 - data.pointList[i].y / data.maxRange;
      double barWidth = size.width / (data.pointList.length * 2 - 1);
      canvas.drawRRect(
          new RRect.fromLTRBR(
              i == 0
                  ? x * size.width
                  : x * size.width -
                      barWidth / data.pointList.length * i -
                      chartPaint.strokeWidth,
              y * size.height,
              i == 0
                  ? x * size.width + barWidth
                  : x * size.width -
                      barWidth / data.pointList.length * i -
                      chartPaint.strokeWidth +
                      barWidth,
              size.height,
              new Radius.circular(5.0)),
          chartPaint);
    }
  }
}
