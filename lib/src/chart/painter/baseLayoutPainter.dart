import 'package:flutter/material.dart';
import 'package:power_chart/power_chart.dart';
import 'package:power_chart/src/configuration/enum.dart';
import 'package:power_chart/src/configuration/indicator.dart';

class BaseLayoutPainter extends CustomPainter {
  final List<Graph> graph;
  final bool showIndicators;
  final Offset touchPoint;
  final Indicator indicator;
  final Color backgroundColor;
  final ChartBorder border;
  final BackgroundGrid backgroundgrid;
  List<List<Offset>> _spotsList;
  double _maxDomain;
  double _maxRange;

  List<List<Offset>> get spotsList => _spotsList;

  BaseLayoutPainter(this.graph,
      {this.showIndicators = false,
      this.touchPoint,
      this.backgroundColor,
      this.indicator,
      this.border,
      this.backgroundgrid});
  void _setScale(Size size) {
    double _maxDomain = graph.first.data.maxDomain;
    double _maxRange = graph.first.data.maxRange;
    for (var i = 1; i < graph.length; i++) {
      if (graph[i].data.maxDomain > _maxDomain) {
        _maxDomain = graph[i].data.maxDomain;
      }
      if (graph[i].data.maxRange > _maxRange) {
        _maxRange = graph[i].data.maxRange;
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _setScale(size);
    _drawBackground(canvas, size);
    _drawBorder(canvas, size);

    _drawChart(canvas, size, graph);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void _drawBackground(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      Paint()..color = backgroundColor,
    );
  }

  void _drawBorder(Canvas canvas, Size size) {
    _drawAxis(canvas, size);
  }

  void _drawAxis(Canvas canvas, Size size) {
    final topLeft = Offset(0, 0);
    final topRight = Offset(size.width, 0);
    final bottomLeft = Offset(0, size.height);
    final bottomRight = Offset(size.width, size.height);

    if (border.top != null) {
      if (border.top.showScale) {
        double scaleUnit = _maxDomain / border.top.scaleCount;
        for (var i = 0; i < border.top.scaleCount; i++) {
          final String text = (scaleUnit * (i + 1)).toStringAsFixed(1);
          final TextSpan span =
              TextSpan(style: border.top.scaleStyle, text: text);
          TextPainter tp = TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr);
          tp.layout();
          double x = double.parse(text);
          double y = 0;
          tp.paint(canvas, Offset(double.parse(text), y + tp.height));
          if (border.top.showScaleIndicator) {
            canvas.drawLine(
                Offset(x, y), Offset(x, y + 5), border.top.indicatorPaint);
          }
          if (backgroundgrid.showVerticalGridLine) {
            canvas.drawLine(Offset(x, y), Offset(x, y + size.height),
                backgroundgrid.verticalGridLinePaint);
          }
        }
      }
      canvas.drawLine(topLeft, topRight, border.top.axisPaint);
    }
    if (border.right != null) {
      canvas.drawLine(topRight, bottomRight, border.right.axisPaint);
    }
    if (border.bottom != null) {
      canvas.drawLine(bottomRight, bottomLeft, border.bottom.axisPaint);
    }

    if (border.left != null) {
      canvas.drawLine(bottomLeft, topLeft, border.left.axisPaint);
    }
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
    }
  }

  void _drawSmoothlineChart(Canvas canvas, Size size, Graph graph) {
    final data = graph.data;
    final domainDistance = data.maxDomain - data.minDoamin;
    List<Offset> _spotList = List<Offset>();
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
      _spotList.add(Offset(x, y));

      Offset controllerPoint1 = Offset((nextx + x) * 0.5, y);
      Offset controllerPoint2 = Offset((nextx + x) * 0.5, nexty);

      path.cubicTo(controllerPoint1.dx, controllerPoint1.dy,
          controllerPoint2.dx, controllerPoint2.dy, nextx, nexty);
    }
    _spotsList.add(_spotList);
    canvas.drawPath(path, graph.chartPaint);
  }

  void _drawPieChart(Canvas canvas, Size size, Graph graph) {}

  void _drawLineChart(Canvas canvas, Size size, Graph graph) {
    final data = graph.data;
    final double domainDistance = data.maxDomain - data.minDoamin;
    List<Offset> _spotList = List<Offset>();
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
      _spotList.add(Offset(x, y));
    }
    _spotsList.add(_spotList);
    canvas.drawPath(path, graph.chartPaint);
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
