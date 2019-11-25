import 'package:flutter/material.dart';
import 'package:power_chart/src/configuration/configuration.dart';
import 'package:power_chart/src/theme/defaultTheme.dart';

typedef Pop<int> = Function(int);
typedef Push<String> = Function(String);

class InheritedChartStateProvider extends InheritedWidget {
  final ChartState state;
  final Push<String> push;
  final Pop<int> pop;
  InheritedChartStateProvider({
    Key key,
    @required this.state,
    @required Widget child,
    @required this.push,
    @required this.pop,
  }) : super(key: key, child: child);

  static InheritedChartStateProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InheritedChartStateProvider);
      

  @override
  bool updateShouldNotify(InheritedChartStateProvider oldWidget) =>
      state != oldWidget.state;
}

class ChartState {
  final List<String> breadCrumbTitles;
  final bool showIndicators;
  final ChartBorder chartBorder;
  final BackgroundGrid backgroundgrid;
  final Color backgroundColor;
  final ChartTheme chartTheme;

  ChartState(this.breadCrumbTitles, this.showIndicators, this.chartBorder,
      this.backgroundgrid, this.backgroundColor, this.chartTheme);

  factory ChartState.init(
          bool showIndicators,
          ChartBorder chartBorder,
          BackgroundGrid backgroundgrid,
          Color backgroundColor,
          Theme chartTheme) =>
      ChartState([]..add("Home"), showIndicators, chartBorder, backgroundgrid,
          backgroundColor, chartTheme ?? DefaultTheme());

  factory ChartState.pop(ChartState lastState, int level) => ChartState(
      lastState.breadCrumbTitles.sublist(0, level),
      lastState.showIndicators,
      lastState.chartBorder,
      lastState.backgroundgrid,
      lastState.backgroundColor,
      lastState.chartTheme);

  factory ChartState.push(ChartState lastState, String label) => ChartState(
      []
        ..addAll(lastState.breadCrumbTitles)
        ..add(label),
      lastState.showIndicators,
      lastState.chartBorder,
      lastState.backgroundgrid,
      lastState.backgroundColor,
      lastState.chartTheme);
}
