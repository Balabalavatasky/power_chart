import 'package:flutter/material.dart';
import 'package:power_chart/power_chart.dart';
import 'package:power_chart/src/configuration/enum.dart';
import 'package:power_chart/src/configuration/indicator.dart';
import 'package:power_chart/src/theme/defaultTheme.dart';

class BaseLayoutPainter extends CustomPainter {
  ChartTheme theme;
  final List<Graph> graph;
  final bool showIndicators;
  final Offset touchPoint;
  Indicator indicator;
  Color backgroundColor;
  ChartBorder border;
  BackgroundGrid backgroundgrid;

  List<List<Offset>> _spotsList = List<List<Offset>>();

  double _maxDomain;
  double _maxRange;
  double _minDomain;
  double _minRange;
  List<List<Offset>> get spotsList => _spotsList;

  BaseLayoutPainter(
    this.graph, {
    this.theme,
    this.showIndicators = false,
    this.touchPoint,
    this.backgroundColor,
    this.indicator,
    this.border,
    this.backgroundgrid,
  }) {
    if (this.theme == null) {
      this.theme = DefaultTheme();
    }
  }

  void _setScale(Size size) {
    _maxDomain = graph.first.data.maxDomain;
    _maxRange = graph.first.data.maxRange;
    _minDomain = graph.first.data.minDoamin;
    _minRange = graph.first.data.minRange;
    for (var i = 1; i < graph.length; i++) {
      if (graph[i].data.maxDomain > _maxDomain) {
        _maxDomain = graph[i].data.maxDomain;
      }
      if (graph[i].data.maxRange > _maxRange) {
        _maxRange = graph[i].data.maxRange;
      }
      if (graph[i].data.minRange < _minRange) {
        _minRange = graph[i].data.minRange;
      }
      if (graph[i].data.minDoamin < _minDomain) {
        _minDomain = graph[i].data.minDoamin;
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _setScale(size);
    _drawBackground(canvas, size);
    _drawAxis(canvas, size);
    _drawChart(canvas, size, graph);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void _drawBackground(Canvas canvas, Size size) {
    final Paint backgroudPaint = Paint();
    backgroudPaint.color = backgroundColor;
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      backgroudPaint,
    );
  }

  void _drawVerticalAxis(Canvas canvas, Size size) {
    for (var i = 0; i < border.verticalAxis.scaleCount; i++) {
      double x = 0;
      double y = size.height / (border.verticalAxis.scaleCount - 1) * i;
      if (border.verticalAxis.showScale != null) {
        TextStyle scaleStyle = border.verticalAxis.scaleStyle;
        if (scaleStyle == null) {
          scaleStyle = this.theme.scaleStyle;
        }
        final String text = (this._minRange +
                (this._maxRange - this._minRange) /
                    (border.horizontalAxis.scaleCount - 1) *
                    i)
            .toStringAsFixed(2);
        TextPainter tp = TextPainter(
            text: TextSpan(style: scaleStyle, text: text),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr)
          ..layout();
        tp.paint(
            canvas, Offset(x - tp.width, size.height - (y + tp.height / 2)));
      }
      if (border.verticalAxis.showScaleIndicator) {
        Paint indicatorPaint = border.verticalAxis.indicatorPaint;
        if (indicatorPaint == null) {
          indicatorPaint = this.theme.indicatorPaint;
        }
        canvas.drawLine(Offset(x, y), Offset(x + 5, y), indicatorPaint);
      }
      if (backgroundgrid.showVerticalGridLine) {
        Paint verticalGridLinePaint = backgroundgrid.verticalGridLinePaint;
        if (verticalGridLinePaint == null) {
          verticalGridLinePaint = this.theme.verticalGridLinePaint;
        }
        canvas.drawLine(
            Offset(x, y), Offset(size.width, y), verticalGridLinePaint);
      }
    }
  }

  void _drawHorizontalAxis(Canvas canvas, Size size) {
    for (var i = 0; i < border.horizontalAxis.scaleCount; i++) {
      double x = size.width / (border.horizontalAxis.scaleCount - 1) * i;
      double y = size.height;
      if (border.horizontalAxis.showScale != null) {
        TextStyle scaleStyle = border.horizontalAxis.scaleStyle;
        if (scaleStyle == null) {
          scaleStyle = this.theme.scaleStyle;
        }
        final String text = (this._minDomain +
                (this._maxDomain - this._minDomain) /
                    (border.horizontalAxis.scaleCount - 1) *
                    i)
            .toStringAsFixed(2);
        TextPainter tp = TextPainter(
            text: TextSpan(style: scaleStyle, text: text),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr)
          ..layout();
        tp.paint(canvas, Offset(x - tp.width / 2, y));
      }
      if (border.horizontalAxis.showScaleIndicator) {
        Paint indicatorPaint = border.horizontalAxis.indicatorPaint;
        if (indicatorPaint == null) {
          indicatorPaint = this.theme.indicatorPaint;
        }
        canvas.drawLine(Offset(x, y), Offset(x, y - 5), indicatorPaint);
      }
      if (backgroundgrid.showVerticalGridLine) {
        Paint verticalGridLinePaint = backgroundgrid.verticalGridLinePaint;
        if (verticalGridLinePaint == null) {
          verticalGridLinePaint = this.theme.verticalGridLinePaint;
        }
        canvas.drawLine(Offset(x, y), Offset(x, 0), verticalGridLinePaint);
      }
    }
  }

  void _drawAxis(Canvas canvas, Size size) {
    _drawHorizontalAxis(canvas, size);
    _drawVerticalAxis(canvas, size);
    _drawBorder(canvas, size);
  }

  void _drawBorder(Canvas canvas, Size size) {
    final topLeft = Offset(0, 0);
    final topRight = Offset(size.width, 0);
    final bottomLeft = Offset(0, size.height);
    final bottomRight = Offset(size.width, size.height);

    if (border.top != null) {
      Paint axisPaint = border.top;
      if (axisPaint == null) {
        axisPaint = this.theme.axisPaint;
      }
      canvas.drawLine(topLeft, topRight, axisPaint);
    }
    if (border.right != null) {
      Paint axisPaint = border.right;
      if (axisPaint == null) {
        axisPaint = this.theme.axisPaint;
      }
      canvas.drawLine(topRight, bottomRight, axisPaint);
    }
    if (border.bottom != null) {
      canvas.drawLine(bottomRight, bottomLeft, border.bottom);
    }

    if (border.left != null) {
      canvas.drawLine(bottomLeft, topLeft, border.left);
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
    final double domainDistance = this._maxDomain - this._minDomain;
    final double rangeDistance = this._maxRange - this._minRange;
    List<Offset> _spotList = List<Offset>();
    final path = Path()
      ..moveTo(
          (data.pointList.first.x - this._minDomain) /
              domainDistance *
              size.width,
          (1 - (data.pointList.first.y - this._minRange) / rangeDistance) *
              size.height);

    for (int i = 0; i < data.pointList.length - 1; i++) {
      double x =
          (data.pointList[i].x - this._minDomain) / domainDistance * size.width;
      double y = (1 - (data.pointList[i].y - this._minRange) / rangeDistance) *
          size.height;

      double nextx = (data.pointList[i + 1].x - this._minDomain) /
          domainDistance *
          size.width;
      double nexty =
          (1 - (data.pointList[i + 1].y - this._minRange) / rangeDistance) *
              size.height;

      path.moveTo(x, y);
      _spotList.add(Offset(x, y));

      Offset controllerPoint1 = Offset((nextx + x) * 0.5, y);
      Offset controllerPoint2 = Offset((nextx + x) * 0.5, nexty);

      path.cubicTo(controllerPoint1.dx, controllerPoint1.dy,
          controllerPoint2.dx, controllerPoint2.dy, nextx, nexty);
    }
    _spotsList.add(_spotList);
    Paint chartPaint = graph.chartPaint;
    if (chartPaint == null) {
      chartPaint = this.theme.linechartPaint;
    }
    canvas.drawPath(path, chartPaint);
  }

  void _drawPieChart(Canvas canvas, Size size, Graph graph) {}

  void _drawLineChart(Canvas canvas, Size size, Graph graph) {
    final data = graph.data;
    final double domainDistance = this._maxDomain - this._minDomain;
    final double rangeDistance = this._maxRange - this._minRange;
    List<Offset> _spotList = List<Offset>();
    final path = Path()
      ..moveTo(
          (data.pointList.first.x - this._minDomain) /
              domainDistance *
              size.width,
          (1 - (data.pointList.first.y - this._minRange) / rangeDistance) *
              size.height);

    for (var i = 1; i < data.pointList.length; i++) {
      double x =
          (data.pointList[i].x - this._minDomain) / domainDistance * size.width;
      double y = (1 - (data.pointList[i].y - this._minRange) / rangeDistance) *
          size.height;
      path.lineTo(x, y);
      _spotList.add(Offset(x, y));
    }
    _spotsList.add(_spotList);
    Paint chartPaint = graph.chartPaint;
    if (chartPaint == null) {
      chartPaint = this.theme.linechartPaint;
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
