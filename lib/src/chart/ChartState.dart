import 'package:flutter/material.dart';

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
      context.inheritFromWidgetOfExactType(InheritedChartStateProvider)
          as InheritedChartStateProvider;

  @override
  bool updateShouldNotify(InheritedChartStateProvider oldWidget) =>
      state != oldWidget.state;
}

class ChartState {
  final List<String> breadCrumbTitles;

  ChartState(this.breadCrumbTitles);

  factory ChartState.init() => ChartState([]..add("Home"));

  factory ChartState.pop(ChartState lastState, int level) =>
      ChartState(lastState.breadCrumbTitles.sublist(0, level));

  factory ChartState.push(ChartState lastState, String label) => ChartState([]
    ..addAll(lastState.breadCrumbTitles)
    ..add(label));
}
