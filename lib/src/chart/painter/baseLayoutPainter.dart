import 'package:flutter/material.dart';
import 'package:power_chart/power_chart.dart';
import 'package:power_chart/src/configuration/enum.dart';
import 'package:power_chart/src/configuration/spot.dart';
import 'package:power_chart/src/theme/defaultTheme.dart';

class BaseLayoutPainter extends CustomPainter {
  ChartTheme theme;
  List<Graph> graph;
  bool showIndicators;
  Offset touchPoint;

  Color backgroundColor;
  ChartBorder border;
  BackgroundGrid backgroundgrid;

  double paddingLeft = 0;
  double paddingBottom = 0;

  double maxDomain;
  double maxRange;
  double minDomain;
  double minRange;

  List<TextPainter> verticalTpList;
  List<TextPainter> horizontalTpList;

  double zeroRangeValue;

  BaseLayoutPainter(
    this.graph, {
    this.paddingBottom,
    this.paddingLeft,
    this.maxRange,
    this.maxDomain,
    this.minRange,
    this.minDomain,
    this.zeroRangeValue,
    this.verticalTpList,
    this.horizontalTpList,
    this.theme,
    this.showIndicators = false,
    this.touchPoint,
    this.backgroundColor,
    this.border,
    this.backgroundgrid,
  }) {
    if (this.theme == null) {
      this.theme = DefaultTheme();
    }
  }
  @override
  void paint(Canvas canvas, Size size) {
    _drawAxis(canvas, size);
    _drawChart(canvas, size, graph);
  }

  @override
  bool shouldRepaint(BaseLayoutPainter oldDelegate) {
    return oldDelegate.graph.length != graph.length;
  }

  void _drawBackground(Canvas canvas, Size size) {
    final Paint backgroudPaint = Paint();
    backgroudPaint.color = backgroundColor;
    canvas.drawRect(
      Rect.fromLTWH(
        paddingLeft,
        0,
        size.width - paddingLeft,
        size.height - paddingBottom,
      ),
      backgroudPaint,
    );
  }

  void _drawVerticalAxis(Canvas canvas, Size size, List<TextPainter> tpList) {
    if (border.verticalAxis != null) {
      //draw axis
      Paint verticalAxisPaint = border.verticalAxisPaint;
      if (verticalAxisPaint == null) {
        verticalAxisPaint = this.theme.axisPaint;
      }
      if (border.showVerticalAxis) {
        canvas.drawLine(
            Offset(paddingLeft, 0),
            Offset(paddingLeft, size.height - paddingBottom),
            verticalAxisPaint);
      }
      for (var i = 0; i < border.verticalAxis.scaleCount; i++) {
        double scaleHeight = (size.height - paddingBottom) *
            0.8 /
            (border.verticalAxis.scaleCount - 1);
        double x = 0;
        double y = scaleHeight * i;
        if (border.verticalAxis.showScale) {
          tpList[i].paint(
              canvas,
              Offset(
                  x,
                  (size.height - paddingBottom) * 0.9 -
                      (y + tpList[i].height / 2)));
        }

        if (border.verticalAxis.showScaleIndicator) {
          Paint indicatorPaint = border.verticalAxis.indicatorPaint;
          if (indicatorPaint == null) {
            indicatorPaint = this.theme.indicatorPaint;
          }
          canvas.drawLine(
              Offset(x + paddingLeft, y + (size.height - paddingBottom) * 0.1),
              Offset(
                  x + 5 + paddingLeft, y + (size.height - paddingBottom) * 0.1),
              indicatorPaint);
        }
        if (backgroundgrid.showVerticalGridLine) {
          Paint verticalGridLinePaint = backgroundgrid.verticalGridLinePaint;
          if (verticalGridLinePaint == null) {
            verticalGridLinePaint = this.theme.verticalGridLinePaint;
          }
          canvas.drawLine(
              Offset(x + paddingLeft, y + (size.height - paddingBottom) * 0.1),
              Offset(size.width + paddingLeft,
                  y + (size.height - paddingBottom) * 0.1),
              verticalGridLinePaint);
        }
      }
    }
  }

  void _drawHorizontalAxis(Canvas canvas, Size size, List<TextPainter> tpList) {
    Paint horizontalAxisPaint = border.horizontalAxisPaint;
    if (horizontalAxisPaint == null) {
      horizontalAxisPaint = this.theme.axisPaint;
    }
    if (border.showHorizontalAxis) {
      canvas.drawLine(Offset(paddingLeft, size.height - paddingBottom),
          Offset(size.width, size.height - paddingBottom), horizontalAxisPaint);
    }
    for (var i = 0; i < border.horizontalAxis.scaleCount; i++) {
      double scaleWidth = (size.width - paddingLeft) *
          0.8 /
          (border.horizontalAxis.scaleCount - 1);
      double x = scaleWidth * i;
      double y = size.height - paddingBottom;
      if (border.horizontalAxis.showScale) {
        tpList[i].paint(
            canvas,
            Offset(
                x +
                    paddingLeft -
                    tpList[i].width / 2 +
                    (size.width - paddingLeft) * 0.1,
                y));
      }
      if (border.horizontalAxis.showScaleIndicator) {
        Paint indicatorPaint = border.horizontalAxis.indicatorPaint;
        if (indicatorPaint == null) {
          indicatorPaint = this.theme.indicatorPaint;
        }
        canvas.drawLine(
            Offset(x + (size.width - paddingLeft) * 0.1 + paddingLeft, y),
            Offset(x + (size.width - paddingLeft) * 0.1 + paddingLeft, y - 5),
            indicatorPaint);
      }
      if (backgroundgrid.showVerticalGridLine) {
        Paint verticalGridLinePaint = backgroundgrid.verticalGridLinePaint;
        if (verticalGridLinePaint == null) {
          verticalGridLinePaint = this.theme.verticalGridLinePaint;
        }
        canvas.drawLine(
            Offset(x + (size.width - paddingLeft) * 0.1 + paddingLeft, y),
            Offset(x + (size.width - paddingLeft) * 0.1 + paddingLeft, 0),
            verticalGridLinePaint);
      }
    }
  }

  void _drawAxis(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawVerticalAxis(canvas, size, verticalTpList);
    _drawHorizontalAxis(canvas, size, horizontalTpList);
  }

  void _drawChart(Canvas canvas, Size size, List<Graph> graphList) {
    for (var graph in graphList) {
      switch (graph.graphType) {
        case CHART_TYPE.sline:
          _drawSplineChart(canvas, size, graph);
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

  void _drawSplineChart(Canvas canvas, Size size, Graph graph) {
    final data = graph.data;

    Path areapath = Path();
    Path curvepath = Path();

    Paint chartPaint = graph.chartPaint;
    if (chartPaint == null) {
      chartPaint = this.theme.linechartPaint;
    }

    var temp = const Offset(0.0, 0.0);
    for (var i = 0; i < data.pointList.length; i++) {
      Offset current =
          Offset(data.pointList[i].coordinateX, data.pointList[i].coordinateY);
      if (i == 0) {
        curvepath.moveTo(
            data.pointList[i].coordinateX, data.pointList[i].coordinateY);
        areapath.moveTo(
            data.pointList[i].coordinateX, data.pointList[i].coordinateY);
      } else {
        //very brilliant spline chart render idea from
        //imaNNeoFighT/fl_chart
        //https://github.com/imaNNeoFighT/fl_chart

        Offset previous = Offset(data.pointList[i - 1].coordinateX,
            data.pointList[i - 1].coordinateY);

        Offset next = Offset(
            data.pointList[i + 1 < data.pointList.length ? i + 1 : i]
                .coordinateX,
            data.pointList[i + 1 < data.pointList.length ? i + 1 : i]
                .coordinateY);

        Offset controllerPoint1 = previous + temp;
        temp = ((next - previous) / 2) * 0.35;

        if (i != data.pointList.length - 1 &&
            ((current - next).dy <= 20 || (previous - current).dy <= 20)) {
          temp = Offset(temp.dx, 0);
        }

        Offset controllerPoint2 = current - temp;

        curvepath.cubicTo(controllerPoint1.dx, controllerPoint1.dy,
            controllerPoint2.dx, controllerPoint2.dy, current.dx, current.dy);
        areapath.cubicTo(controllerPoint1.dx, controllerPoint1.dy,
            controllerPoint2.dx, controllerPoint2.dy, current.dx, current.dy);
      }
    }

    Area area = graph.area;
    if (area == null) {
      area = this.theme.area;
    }
    if (area.showArea) {
      Paint areaPaint = Paint();
      areaPaint.style = PaintingStyle.fill;
      if (area.color != null) {
        areaPaint.color = area.color.withOpacity(area.opacity);
      }

      if (minRange > 0) {
      } else {
        areapath.lineTo(data.pointList.last.coordinateX, zeroRangeValue);
        areapath.lineTo(data.pointList.first.coordinateX, zeroRangeValue);
        areapath.lineTo(
            data.pointList.first.coordinateX, data.pointList.first.coordinateY);
      }
      canvas.drawPath(areapath, areaPaint);
    }

    canvas.drawPath(curvepath, chartPaint);

    Spot spot = graph.spot;
    if (spot == null) {
      spot = this.theme.spot;
    }
    if (spot.color == null) {
      spot.color = chartPaint.color;
    }
    if (spot.showSpots) {
      for (var point in data.pointList) {
        drawSpot(canvas, point.coordinateX, point.coordinateY, spot);
      }
    }
  }

  void _drawPieChart(Canvas canvas, Size size, Graph graph) {}

  void _drawLineChart(Canvas canvas, Size size, Graph graph) {
    final data = graph.data;
    final double domainDistance = this.maxDomain - this.minDomain;
    final double rangeDistance = this.maxRange - this.minRange;

    final path = Path();

    Paint chartPaint = graph.chartPaint;
    if (chartPaint == null) {
      chartPaint = this.theme.linechartPaint;
    }

    for (var i = 0; i < data.pointList.length; i++) {
      data.pointList[i].coordinateX = (data.pointList[i].x - this.minDomain) /
              domainDistance *
              (size.width - paddingLeft) *
              0.8 +
          paddingLeft +
          0.1 * (size.width - paddingLeft);
      data.pointList[i].coordinateY =
          (1 - (data.pointList[i].y - this.minRange) / rangeDistance) *
                  (size.height - paddingBottom) *
                  0.8 +
              0.1 * (size.height - paddingBottom);
      if (i == 0) {
        path.moveTo(
            data.pointList[i].coordinateX, data.pointList[i].coordinateY);
      } else {
        path.lineTo(
            data.pointList[i].coordinateX, data.pointList[i].coordinateY);
      }
      Spot spot = graph.spot;
      if (spot == null) {
        spot = this.theme.spot;
      }
      if (spot.color == null) {
        spot.color = chartPaint.color;
      }
      drawSpot(canvas, data.pointList[i].coordinateX,
          data.pointList[i].coordinateY, spot);
    }

    canvas.drawPath(path, chartPaint);
  }

  void drawSpot(Canvas canvas, double x, double y, Spot spot) {
    if (spot.showSpots) {
      Paint spotPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = spot.color;
      switch (spot.marker) {
        case SPOT_SYMBOL.circle:
          canvas.drawCircle(Offset(x, y), spot.spotSize / 2, spotPaint);
          break;
        case SPOT_SYMBOL.diamond:
          canvas.drawPath(
              Path()
                ..moveTo(x - 0.7 * spot.spotSize, y)
                ..lineTo(x, y - 0.7 * spot.spotSize)
                ..lineTo(x + 0.7 * spot.spotSize, y)
                ..lineTo(x, y + 0.7 * spot.spotSize),
              spotPaint);
          break;
        case SPOT_SYMBOL.square:
          canvas.drawRect(
              Rect.fromCenter(
                  center: Offset(x, y),
                  width: spot.spotSize * 2,
                  height: spot.spotSize * 2),
              spotPaint);
          break;
        case SPOT_SYMBOL.trangle:
          canvas.drawPath(
              Path()
                ..moveTo(x - 0.7 * spot.spotSize, y)
                ..lineTo(x, y - 0.7 * spot.spotSize)
                ..lineTo(x + 0.7 * spot.spotSize, y),
              spotPaint);
          break;
        case SPOT_SYMBOL.triangle_down:
          canvas.drawPath(
              Path()
                ..moveTo(x - 0.7 * spot.spotSize, y)
                ..lineTo(x, y + 0.7 * spot.spotSize)
                ..lineTo(x + 0.7 * spot.spotSize, y),
              spotPaint);
          break;
      }
    }
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
