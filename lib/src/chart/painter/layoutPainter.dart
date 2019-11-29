import 'package:flutter/material.dart';
import 'package:power_chart/power_chart.dart';
import 'package:power_chart/src/chart/painter/baseLayoutPainter.dart';
import 'package:power_chart/src/configuration/enum.dart';
import 'package:power_chart/src/configuration/indicator.dart';
import 'package:power_chart/src/configuration/spot.dart';
import 'package:power_chart/src/model/AxisScale.dart';
import 'package:power_chart/src/theme/defaultTheme.dart';

class LayoutPainter extends BaseLayoutPainter {
  final ChartTheme theme;
  final List<Graph> graphList;
  final Color backgroundColor;
  final ChartBorder border;
  final BackgroundGrid backgroundgrid;

  final double paddingLeft;
  final double paddingBottom;

  final double maxDomain;
  final double maxRange;
  final double minDomain;
  final double minRange;

  final List<TextPainter> verticalTpList;
  final List<AxisScale> horizontalTpList;

  final double zeroRangeValue;
  final bool showIndicators;
  final Offset touchPoint;
  final List<Indicator> indicators;

  LayoutPainter(
    this.theme,
    this.graphList,
    this.backgroundColor,
    this.border,
    this.backgroundgrid,
    this.paddingLeft,
    this.paddingBottom,
    this.maxDomain,
    this.maxRange,
    this.minDomain,
    this.minRange,
    this.verticalTpList,
    this.horizontalTpList,
    this.zeroRangeValue,
    this.showIndicators,
    this.touchPoint,
    this.indicators,
  ) : super(
            graphList,
            paddingBottom,
            paddingLeft,
            maxRange,
            maxDomain,
            minRange,
            minDomain,
            zeroRangeValue,
            verticalTpList,
            horizontalTpList,
            theme,
            backgroundColor,
            border,
            backgroundgrid);

  @override
  void paint(Canvas canvas, Size size) {
    print('layoutPaint!');
    super.paint(canvas, size);
    if ((showIndicators || graphList.any((g) => g.canDrilldown)) &&
        touchPoint != null &&
        indicators != null) {
      _handleTouch(canvas, size);
    }
  }

  @override
  bool shouldRepaint(LayoutPainter oldDelegate) {
    return showIndicators && oldDelegate.touchPoint != touchPoint;
  }

  void _handleTouch(Canvas canvas, Size size) {
    if (indicators.length > 0 && showIndicators) {
      _drawIndicators(canvas, size, indicators);
      _drawTooltip(canvas, EdgeInsets.fromLTRB(10, 5, 10, 5), indicators);
    }
  }

  void _drawIndicators(Canvas canvas, Size size, List<Indicator> indicators) {
    if (indicators.length > 0) {
      for (var i = 0; i < indicators.length; i++) {
        if (indicators[i] != null) {
          if (i == indicators.length - 1) {
            canvas.drawLine(
                indicators[i].position,
                Offset(indicators[i].position.dx, size.height - paddingBottom),
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
          drawSpot(canvas, indicators[i].position.dx, indicators[i].position.dy,
              tooltipSpot);
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
}
