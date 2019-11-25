import 'package:flutter/material.dart';
import 'package:power_chart/src/chart/ChartState.dart';
import 'package:power_chart/src/chart/painter/baseLayoutPainter.dart';
import 'package:power_chart/src/chart/painter/indicatorPainter.dart';
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
  Graph _selecetedGraph;
  String _selectedLabel;
  Offset touchPoint;
  double _maxDomain;
  double _maxRange;
  double _minDomain;
  double _minRange;
  double paddingBottom = 0;
  double paddingLeft = 0;
  List<Indicator> indicators;

  InheritedChartStateProvider chartProvider;
  @override
  void initState() {
    graphList = widget.graph;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chartProvider = InheritedChartStateProvider.of(context);
  }

  void _handleDrilldown() {
    for (var graph in graphList) {
      if (graph.canDrilldown &&
          chartProvider.state.breadCrumbTitles.length <=
              graph.drilldownList.length) {
        for (var spot in graph.data.pointList) {
          if (spot.coordinateX > touchPoint.dx + 10) {
            break;
          } else if ((touchPoint.dx - spot.coordinateX).abs() <= 10 &&
              (touchPoint.dy - spot.coordinateY).abs() <= 10) {
            chartProvider.push(spot.xLabel);
            _selecetedGraph = graph;
            _selectedLabel = spot.xLabel;
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
            if (spot.coordinateX > touchPoint.dx + 10) {
              break;
            } else if ((touchPoint.dx - spot.coordinateX).abs() <= 10) {
              Paint chartPaint = graph.chartPaint;
              if (chartPaint == null) {
                chartPaint = chartProvider.state.chartTheme.linechartPaint;
              }
              indicators.add(Indicator(
                name: graph.name,
                rangeValue: spot.y.toString(),
                domainValue: spot.x.toString(),
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
                chartPaint = chartProvider.state.chartTheme.linechartPaint;
              }
              indicators.add(Indicator(
                name: graph.name,
                rangeValue: spot.y.toString(),
                domainValue: spot.x.toString(),
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
    }

    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    if (chartProvider.state.breadCrumbTitles.length == 1) {
      _selectedLabel = null;
      _selecetedGraph = null;
      graphList = widget.graph;
    } else {
      var g = _selecetedGraph
          .drilldownList[chartProvider.state.breadCrumbTitles.length - 2];
      g.data.initData(_selectedLabel);
      graphList = []..add(g);
    }
    _maxDomain = 0;
    _maxRange = 0;
    _minDomain = 0;
    _minRange = 0;
    for (var i = 0; i < graphList.length; i++) {
      if (graphList[i].data.maxDomain > _maxDomain) {
        _maxDomain = graphList[i].data.maxDomain;
      }
      if (graphList[i].data.maxRange > _maxRange) {
        _maxRange = graphList[i].data.maxRange;
      }
      if (graphList[i].data.minRange < _minRange) {
        _minRange = graphList[i].data.minRange;
      }
      if (graphList[i].data.minDoamin < _minDomain) {
        _minDomain = graphList[i].data.minDoamin;
      }
    }
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
            graph.data.pointList[i].coordinateX = _getDomainPixelPosition(
                graph.data.pointList[i].x,
                domainDistance,
                constraints.biggest.width);
            graph.data.pointList[i].coordinateY = _getRangePixelPosition(
                graph.data.pointList[i].y,
                rangeDistance,
                constraints.biggest.height);
          }
        }

        final baselayoutpaint = BaseLayoutPainter(
            graphList,
            paddingBottom,
            paddingLeft,
            _maxRange,
            _maxDomain,
            _minRange,
            _minDomain,
            zeroRangeValue,
            verticalTpList,
            horizontalTpList,
            chartProvider.state.chartTheme,
            chartProvider.state.showIndicators,
            chartProvider.state.backgroundColor,
            chartProvider.state.chartBorder,
            chartProvider.state.backgroundgrid);

        final indicatorPaint = IndicatorPainter(
            chartProvider.state.chartTheme,
            graphList,
            chartProvider.state.showIndicators,
            touchPoint,
            chartProvider.state.backgroundColor,
            chartProvider.state.chartBorder,
            chartProvider.state.backgroundgrid,
            paddingBottom,
            indicators);

        return GestureDetector(
          onPanUpdate: (detail) {
            if (chartProvider.state.showIndicators) {
              setState(() {
                indicators = _getIndicators();
                touchPoint = detail.localPosition;
              });
            }
          },
          onPanStart: (detail) {
            if (chartProvider.state.showIndicators) {
              setState(() {
                touchPoint = detail.localPosition;
                _handleDrilldown();

                print('state change');
              });
            }
          },
          onPanEnd: (detail) {
            if (chartProvider.state.showIndicators) {
              setState(() {
                touchPoint = null;
                indicators = _getIndicators();
              });
            }
          },
          child: CustomPaint(
            size: constraints.biggest,
            foregroundPainter: indicatorPaint,
            child: CustomPaint(
              size: constraints.biggest,
              painter: baselayoutpaint,
            ),
          ),
        );
      },
    );
  }
}
