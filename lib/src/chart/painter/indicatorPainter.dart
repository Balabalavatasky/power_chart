import 'package:flutter/material.dart';
import 'package:power_chart/power_chart.dart';
import 'package:power_chart/src/chart/painter/baseLayoutPainter.dart';
import 'package:power_chart/src/configuration/enum.dart';
import 'package:power_chart/src/configuration/indicator.dart';
import 'package:power_chart/src/configuration/spot.dart';
import 'package:power_chart/src/theme/defaultTheme.dart';

typedef DrilldownFunc<Offset> = Function(Offset);

class IndicatorPainter extends BaseLayoutPainter {
  ChartTheme theme;
  List<Graph> graphList;
  bool showIndicators;
  Offset touchPoint;
  Color backgroundColor;
  ChartBorder border;
  BackgroundGrid backgroundgrid;
  String touchOperation;
  DrilldownFunc<double> onDrilldown;
  Size chartSize;
  Offset canvasOffset;

  IndicatorPainter(this.graphList, this.showIndicators, this.touchPoint,
      this.backgroundColor, this.border, this.backgroundgrid,
      {this.touchOperation, this.onDrilldown})
      : super(graphList,
            showIndicators: showIndicators,
            touchPoint: touchPoint,
            backgroundColor: backgroundColor,
            border: border,
            backgroundgrid: backgroundgrid) {
    if (this.theme == null) {
      this.theme = DefaultTheme();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if ((showIndicators || graphList.any((g) => g.canDrilldown)) &&
        touchPoint != null) {
      _handleTouch(canvas, size);
    }
  }

  @override
  bool shouldRepaint(IndicatorPainter oldDelegate) {
    return showIndicators && oldDelegate.touchPoint != touchPoint;
  }

  void _handleTouch(Canvas canvas, Size size) {
    List<Indicator> indicators = _getIndicators(canvas, size);
    if (indicators.length > 0 && showIndicators) {
      _drawIndicators(canvas, size, indicators);
      _drawTooltip(canvas, EdgeInsets.fromLTRB(10, 5, 10, 5), indicators);
    }

    if (indicators.length > 0 &&
        graphList.any((g) => g.canDrilldown) &&
        touchOperation == "onPanStart") {
      _handleDrilldown(indicators);
    }
  }

  void _drawIndicators(Canvas canvas, Size size, List<Indicator> indicators) {
    if (indicators.length > 0) {
      for (var i = 0; i < indicators.length; i++) {
        if (indicators[i] != null) {
          if (i == indicators.length - 1) {
            canvas.drawLine(
                indicators[i].position,
                Offset(indicators[i].position.dx,
                    size.height - super.paddingBottom),
                indicators[i].indicatorPaint);
          } else {
            canvas.drawLine(
                indicators[i].position,
                Offset(indicators[i + 1].position.dx,
                    indicators[i + 1].position.dy),
                indicators[i].indicatorPaint);
          }
          Spot tooltipSpot = Spot(showSpots: true);
          if (indicators[i].spot == null) {
            tooltipSpot.color = indicators[i].indicatorPaint.color;
            tooltipSpot.marker = SPOT_SYMBOL.circle;
          } else {
            tooltipSpot.color = indicators[i].spot.color;
            tooltipSpot.marker = indicators[i].spot.marker;
          }
          super.drawSpot(canvas, indicators[i].position.dx,
              indicators[i].position.dy, tooltipSpot);
        }
      }
    }
  }

  void _drawTooltip(
      Canvas canvas, EdgeInsets padding, List<Indicator> indicators) {
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

      Spot tooltipSpot = Spot(showSpots: true);
      if (indicators[i].spot == null) {
        tooltipSpot.color = indicators[i].indicatorPaint.color;
        tooltipSpot.marker = SPOT_SYMBOL.circle;
      } else {
        tooltipSpot.color = indicators[i].spot.color;
        tooltipSpot.marker = indicators[i].spot.marker;
      }
      drawSpot(canvas, circlePosition.dx, circlePosition.dy, tooltipSpot);
      indicators[i].nameTextPainter.paint(
          canvas,
          Offset(topLeft.dx + padding.left + circleRedius * 2 + padding.left,
              topLeft.dy + padding.top + (nameHeight + padding.top) * i));
    }
  }

  List<Indicator> _getIndicators(Canvas canvas, Size size) {
    List<Indicator> indicators = List<Indicator>();

    super.getHorizontalAxisScaleText(canvas, size);

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
              spot: graph.spot,
              position: Offset(spot.coordinateX, spot.coordinateY),
              indicatorPaint: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = chartPaint.color,
            ));
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
              spot: graph.spot,
              position: Offset(spot.coordinateX, spot.coordinateY),
              indicatorPaint: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = chartPaint.color,
            ));
            break;
          }
        }
      }
    }

    return indicators;
  }

  void _handleDrilldown(List<Indicator> indicators) {
    for (var indicator in indicators) {
      if ((indicator.position.dx - touchPoint.dx).abs() <= 10 &&
          (indicator.position.dy - touchPoint.dy).abs() <= 10) {
        if (this.onDrilldown != null) {
          this.onDrilldown(1.02);
        }
        break;
      }
    }
  }
}
