import 'package:flutter/material.dart';
import 'package:power_chart/src/chart/BreadCrumb.dart';
import 'package:power_chart/src/chart/Chart.dart';
import 'package:power_chart/src/chart/ChartState.dart';
import 'package:power_chart/src/configuration/backgroundGrid.dart';
import 'package:power_chart/src/configuration/chartBorder.dart';
import 'package:power_chart/src/configuration/graph.dart';
import 'package:power_chart/src/configuration/indicator.dart';

class PowerChart extends StatefulWidget {
  final Color backgroundColor;
  final List<Graph> graph;
  final bool showIndicators;
  final Indicator indicator;
  final ChartBorder chartBorder;
  final BackgroundGrid backgroundgrid;
  PowerChart(this.graph,
      {Key key,
      this.backgroundColor,
      this.showIndicators,
      this.indicator,
      this.chartBorder,
      this.backgroundgrid})
      : super(key: key);

  @override
  _PowerChartState createState() => _PowerChartState();
}

class _PowerChartState extends State<PowerChart> {
  ChartState chartState;
  @override
  void initState() {
    chartState = ChartState.init();
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
            child: Chart(
              widget.graph,
              backgroundColor: Colors.green[100],
              chartBorder: widget.chartBorder,
              backgroundgrid: widget.backgroundgrid,
              showIndicators: true,
              indicator: widget.indicator,
            ),
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
