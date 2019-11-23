import 'package:flutter/material.dart';

class InheritedChartStateBuilder extends InheritedWidget {
  final ChartState state;

  InheritedChartStateBuilder(
      {Key key, @required this.state, @required Widget child})
      : super(key: key, child: child);

  static ChartState of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(InheritedChartStateBuilder)
              as InheritedChartStateBuilder)
          .state;

  @override
  bool updateShouldNotify(InheritedChartStateBuilder oldWidget) =>
      state != oldWidget.state;
}

class ChartState {
  List<String> breadCrumbTitles;

  ChartState({this.breadCrumbTitles});

  factory ChartState.init() => ChartState(breadCrumbTitles: []..add("Home"));
}
