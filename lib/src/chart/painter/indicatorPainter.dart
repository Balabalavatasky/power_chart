import 'package:flutter/material.dart';
import 'package:power_chart/power_chart.dart';
import 'package:power_chart/src/chart/painter/baseLayoutPainter.dart';
import 'package:power_chart/src/configuration/indicator.dart';

class IndicatorPainter extends BaseLayoutPainter {
  List<Graph> graphList;
  bool showIndicators;
  Offset touchPoint;
  Color backgroundColor;
  ChartBorder border;
  BackgroundGrid backgroundgrid;

  IndicatorPainter(this.graphList, this.showIndicators, this.touchPoint,
      this.backgroundColor, this.border, this.backgroundgrid)
      : super(graphList,
            showIndicators: showIndicators,
            touchPoint: touchPoint,
            backgroundColor: backgroundColor,
            border: border,
            backgroundgrid: backgroundgrid);

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    if (showIndicators && touchPoint != null) {
      _drawIndicators(canvas, size);
    }
  }

  @override
  bool shouldRepaint(IndicatorPainter oldDelegate) {
    return showIndicators && oldDelegate.touchPoint != touchPoint;
  }

  void _drawTooltip(
      Canvas canvas, EdgeInsets padding, List<Indicator> indicators) {
    //calculate center point position
    double maxNameWidth = 0;
    double nameHeight = indicators.first.nameTextPainter.height;
    for (var indicator in indicators) {
      if (indicator.nameTextPainter.width > maxNameWidth)
        maxNameWidth = indicator.nameTextPainter.width;
    }
    double width = maxNameWidth + padding.left * 2 + padding.right + nameHeight;
    double height =
        (nameHeight + padding.top) * indicators.length + padding.bottom;

    //drawBackground
    indicators.sort((x1, x2) {
      return x1.position.dy.compareTo(x2.position.dy);
    });
    Paint recPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey[200];
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(indicators.first.position.dx,
                indicators.first.position.dy - height / 2 - 10),
            width: width,
            height: height),
        recPaint);
    Offset topLeft = Offset(indicators.first.position.dx - width / 2,
        indicators.first.position.dy - height - 10);
    double circleRedius = nameHeight / 2 * 0.5;
    for (var i = 0; i < indicators.length; i++) {
      Offset circlePosition = Offset(
          topLeft.dx + padding.left + circleRedius,
          topLeft.dy +
              padding.top +
              nameHeight / 2 +
              (nameHeight + padding.top) * i);
      canvas.drawCircle(circlePosition, circleRedius, indicators[i].spotPaint);
      indicators[i].nameTextPainter.paint(
          canvas,
          Offset(topLeft.dx + padding.left + circleRedius * 2 + padding.left,
              topLeft.dy + padding.top + (nameHeight + padding.top) * i));
    }
  }

  void _drawIndicators(Canvas canvas, Size size) {
    List<Indicator> indicators = List<Indicator>();
    for (var graph in graphList) {
      for (var spot in graph.data.pointList) {
        if (indicators.length == 0) {
          if (spot.coordinateX > touchPoint.dx + 10) {
            break;
          } else if ((touchPoint.dx - spot.coordinateX).abs() <= 10) {
            Paint chartPaint = graph.chartPaint;
            if (chartPaint == null) {
              chartPaint = this.theme.linechartPaint;
            }
            indicators.add(Indicator(
                name: graph.name,
                value: spot.y.toString(),
                showSpot: graph.spot == null ? true : !graph.spot.showSpots,
                position: Offset(spot.coordinateX, spot.coordinateY),
                indicatorPaint: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = chartPaint.color,
                spotPaint: Paint()
                  ..style = PaintingStyle.fill
                  ..color = chartPaint.color));
            break;
          }
        } else {
          if (indicators.first.position.dx == spot.coordinateX) {
            Paint chartPaint = graph.chartPaint;
            if (chartPaint == null) {
              chartPaint = this.theme.linechartPaint;
            }
            indicators.add(Indicator(
                name: graph.name,
                value: spot.y.toString(),
                showSpot: graph.spot == null ? true : !graph.spot.showSpots,
                position: Offset(spot.coordinateX, spot.coordinateY),
                indicatorPaint: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = chartPaint.color,
                spotPaint: Paint()
                  ..style = PaintingStyle.fill
                  ..color = chartPaint.color));
            break;
          }
        }
      }
    }

    if (indicators.length > 0) {
      _drawTooltip(canvas, EdgeInsets.fromLTRB(10, 5, 10, 5), indicators);

      for (var i = 0; i < indicators.length; i++) {
        if (indicators[i] != null) {
          if (i == indicators.length - 1) {
            canvas.drawLine(
                indicators[i].position,
                Offset(indicators[i].position.dx, size.height),
                indicators[i].indicatorPaint);
          } else {
            canvas.drawLine(
                indicators[i].position,
                Offset(indicators[i + 1].position.dx,
                    indicators[i + 1].position.dy),
                indicators[i].indicatorPaint);
          }
          if (indicators[i].showSpot) {
            canvas.drawCircle(indicators[i].position, indicators[i].spotSize,
                indicators[i].spotPaint);
          }
        }
      }
    }
  }
}
