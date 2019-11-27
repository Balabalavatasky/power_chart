import 'package:flutter/material.dart';
import 'package:power_chart/src/chart/ChartState.dart';
import 'package:power_chart/src/chart/painter/layoutPainter.dart';
import 'package:power_chart/src/configuration/graph.dart';
import 'package:power_chart/src/configuration/indicator.dart';

class Chart extends StatefulWidget {
  final List<Graph> graph;

  Chart(
    this.graph, {
    Key key,
  }) : super(key: key);

  @override
  _PowerChartState createState() => _PowerChartState();
}

class _PowerChartState extends State<Chart> {
  List<Graph> graphList;
  Offset touchPoint;
  double _maxDomain;
  double _maxRange;
  double _minDomain;
  double _minRange;
  double paddingBottom = 0;
  double paddingLeft = 0;
  List<Indicator> indicators;
  InheritedChartStateProvider chartProvider;
  bool hitFlag = false;
  @override
  void initState() {
    graphList = widget.graph;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('change dependency!');
    super.didChangeDependencies();
    chartProvider = InheritedChartStateProvider.of(context);
    if (chartProvider != null &&
        chartProvider.state.breadCrumbTitles.length == 0) {
      graphList = widget.graph;
    }

    _maxDomain = 0;
    _maxRange = 0;
    _minDomain = 0;
    _minRange = 0;

    for (var i = 0; i < graphList.length; i++) {
      if (graphList[i].data.maxSeriesDomain > _maxDomain) {
        _maxDomain = graphList[i].data.maxSeriesDomain;
      }
      if (graphList[i].data.maxSeriesRange > _maxRange) {
        _maxRange = graphList[i].data.maxSeriesRange;
      }
      if (graphList[i].data.minSeriesRange < _minRange) {
        _minRange = graphList[i].data.minSeriesRange;
      }
      if (graphList[i].data.minSeriesDoamin < _minDomain) {
        _minDomain = graphList[i].data.minSeriesDoamin;
      }
    }
  }

  void _handleDrilldown() {
    for (var graph in graphList) {
      if (graph.canDrilldown &&
          chartProvider.state.breadCrumbTitles.length <=
              graph.drilldownList.length) {
        for (var spot in graph.data.pointList) {
          if (spot.pixelX > touchPoint.dx + 10) {
            break;
          } else if ((touchPoint.dx - spot.pixelX).abs() <= 10 &&
              (touchPoint.dy - spot.pixelY).abs() <= 10) {
            chartProvider.push(spot.xLabel);
            var g = graph
                .drilldownList[chartProvider.state.breadCrumbTitles.length];
            g.data.initData(spot.xLabel);
            graphList = []..add(g);
            break;
          }
        }
      }
    }
  }

  List<TextPainter> getVerticalAxisScaleText() {
    List<TextPainter> tpList = List<TextPainter>();
    //get the max width of scale text
    if (chartProvider.state.chartBorder.verticalAxis.showScale) {
      for (var i = 0;
          i < chartProvider.state.chartBorder.verticalAxis.scaleCount;
          i++) {
        TextStyle scaleStyle =
            chartProvider.state.chartBorder.verticalAxis.scaleStyle;
        if (scaleStyle == null) {
          scaleStyle = chartProvider.state.chartTheme.scaleStyle;
        }
        final String text = (_minRange +
                (_maxRange - _minRange) /
                    (chartProvider.state.chartBorder.horizontalAxis.scaleCount -
                        1) *
                    i)
            .toStringAsFixed(2);
        TextPainter tp = TextPainter(
            text: TextSpan(style: scaleStyle, text: text),
            textAlign: TextAlign.right,
            textDirection: TextDirection.ltr)
          ..layout();
        tpList.add(tp);
        if (paddingLeft < tp.width) {
          paddingLeft = tp.width;
        }
      }
    }
    return tpList;
  }

  List<TextPainter> getHorizontalAxisScaleText() {
    List<TextPainter> tpList = List<TextPainter>();
    TextStyle scaleStyle =
        chartProvider.state.chartBorder.horizontalAxis.scaleStyle;
    if (scaleStyle == null) {
      scaleStyle = chartProvider.state.chartTheme.scaleStyle;
    }
    if (chartProvider.state.chartBorder.horizontalAxis.showScale) {
      for (var i = 0; i < graphList.length; i++) {
        if (graphList[i].data.domainDataType == String) {
          for (var j = 0; j < graphList[i].data.pointList.length; j++) {
            String text = graphList[i].data.pointList[j].xLabel;
            TextPainter tp = TextPainter(
                text: TextSpan(style: scaleStyle, text: text),
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr)
              ..layout();
            tpList.add(tp);
            if (paddingBottom < tp.height) {
              paddingBottom = tp.height;
            }
          }
        } else {
          for (var i = 0;
              i < chartProvider.state.chartBorder.horizontalAxis.scaleCount;
              i++) {
            String text = (_minDomain +
                    (_maxDomain - _minDomain) /
                        (chartProvider
                                .state.chartBorder.horizontalAxis.scaleCount -
                            1) *
                        i)
                .toStringAsFixed(2);
            TextPainter tp = TextPainter(
                text: TextSpan(style: scaleStyle, text: text),
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr)
              ..layout();
            tpList.add(tp);
            if (paddingBottom < tp.height) {
              paddingBottom = tp.height;
            }
          }
        }
      }
    }
    return tpList;
  }

  double _getRangePixelPosition(
      double rangeValue, double rangeDistance, double height) {
    return (1 - (rangeValue - _minRange) / rangeDistance) *
            (height - paddingBottom) *
            0.8 +
        0.1 * (height - paddingBottom);
  }

  double _getDomainPixelPosition(
      double domainValue, double domainDistance, double width) {
    return (domainValue - _minDomain) /
            domainDistance *
            (width - paddingLeft) *
            0.8 +
        paddingLeft +
        0.1 * (width - paddingLeft);
  }

  List<Indicator> _getIndicators() {
    List<Indicator> indicators = List<Indicator>();
    if (touchPoint != null) {
      for (var graph in graphList) {
        for (var spot in graph.data.pointList) {
          if (indicators.length == 0) {
            if (spot.pixelX > touchPoint.dx + 10) {
              break;
            } else if ((touchPoint.dx - spot.pixelX).abs() <= 10) {
              Paint chartPaint = graph.chartPaint;
              if (chartPaint == null) {
                chartPaint = chartProvider.state.chartTheme.linechartPaint;
              }
              indicators.add(Indicator(
                name: graph.name,
                rangeValue: spot.y.toString(),
                domainValue: spot.x.toString(),
                spot: graph.spot,
                position: Offset(spot.pixelX, spot.pixelY),
                indicatorPaint: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = chartPaint.color,
              ));
              break;
            }
          } else {
            if (indicators.first.position.dx == spot.pixelX) {
              Paint chartPaint = graph.chartPaint;
              if (chartPaint == null) {
                chartPaint = chartProvider.state.chartTheme.linechartPaint;
              }
              indicators.add(Indicator(
                name: graph.name,
                rangeValue: spot.y.toString(),
                domainValue: spot.x.toString(),
                spot: graph.spot,
                position: Offset(spot.pixelX, spot.pixelY),
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
    }

    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    print('chartBuild!');
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var verticalTpList = getVerticalAxisScaleText();
        var horizontalTpList = getHorizontalAxisScaleText();
        final double domainDistance = _maxDomain - _minDomain;
        final double rangeDistance = _maxRange - _minRange;
        final double zeroRangeValue = _getRangePixelPosition(
            0, rangeDistance, constraints.biggest.height);

        for (var graph in graphList) {
          for (var i = 0; i < graph.data.pointList.length; i++) {
            graph.data.pointList[i].pixelX = _getDomainPixelPosition(
                graph.data.pointList[i].x,
                domainDistance,
                constraints.biggest.width);
            graph.data.pointList[i].pixelY = _getRangePixelPosition(
                graph.data.pointList[i].y,
                rangeDistance,
                constraints.biggest.height);
          }
        }

        final indicatorPaint = LayoutPainter(
            chartProvider.state.chartTheme,
            graphList,
            chartProvider.state.backgroundColor,
            chartProvider.state.chartBorder,
            chartProvider.state.backgroundgrid,
            paddingLeft,
            paddingBottom,
            _maxDomain,
            _maxRange,
            _minDomain,
            _minRange,
            verticalTpList,
            horizontalTpList,
            zeroRangeValue,
            chartProvider.state.showIndicators,
            touchPoint,
            indicators);

        return GestureDetector(
          onPanUpdate: (detail) {
            if (chartProvider.state.showIndicators) {
              touchPoint = detail.localPosition;
              indicators = _getIndicators();
              if (indicators.length > 0 && hitFlag == false) {
                setState(() {
                  hitFlag = true;
                });
              } else if (indicators.length == 0 && hitFlag == true) {
                setState(() {
                  hitFlag = false;
                });
              }
            }
          },
          onPanDown: (detail) {
            if (chartProvider.state.showIndicators) {
              touchPoint = detail.localPosition;
              setState(() {
                _handleDrilldown();
              });
            }
          },
          onPanEnd: (detail) {
            if (chartProvider.state.showIndicators) {
              touchPoint = null;
              setState(() {});
            }
          },
          child: CustomPaint(
            size: constraints.biggest,
            painter: indicatorPaint,
          ),
        );
      },
    );
  }
}
