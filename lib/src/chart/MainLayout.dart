import 'package:flutter/material.dart';
import 'package:power_chart/src/chart/BreadCrumb.dart';
import 'package:power_chart/src/chart/Chart.dart';
import 'package:power_chart/src/chart/ChartState.dart';
import 'package:power_chart/src/configuration/backgroundGrid.dart';
import 'package:power_chart/src/configuration/chartBorder.dart';
import 'package:power_chart/src/configuration/graph.dart';

class PowerChart extends StatefulWidget {
  final Color backgroundColor;
  final List<Graph> graph;
  final bool showIndicators;
  final ChartBorder chartBorder;
  final BackgroundGrid backgroundgrid;
  final Theme chartTheme;
  PowerChart(this.graph,
      {Key key,
      this.backgroundColor,
      this.showIndicators,
      this.chartBorder,
      this.backgroundgrid,
      this.chartTheme
      })
      : super(key: key);

  @override
  _PowerChartState createState() => _PowerChartState();
}

class _PowerChartState extends State<PowerChart> {
  ChartState chartState;
  @override
  void initState() {
    chartState = ChartState.init(widget.showIndicators, widget.chartBorder,
        widget.backgroundgrid, widget.backgroundColor,widget.chartTheme);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedChartStateProvider(
      state: chartState,
      child: Column(
        children: <Widget>[
          BreadCrumb(),
          Expanded(
            child: Chart(widget.graph),
          )
        ],
      ),
      pop: (level) {
        setState(() {
          chartState = ChartState.pop(chartState, level);
        });
      },
      push: (label) {
        setState(() {
          chartState = ChartState.push(chartState, label);
        });
      },
    );
  }
}
