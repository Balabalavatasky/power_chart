import 'package:flutter/material.dart';
import 'package:power_chart/src/chart/ChartState.dart';

class BreadCrumb extends StatelessWidget {
  const BreadCrumb({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InheritedChartStateProvider stateProvider =
        InheritedChartStateProvider.of(context);
    return Row(
      children: getBreadCrumbs(stateProvider),
    );
  }

  List<Widget> getBreadCrumbs(InheritedChartStateProvider stateProvider) {
    List<Widget> wList = []..add(InkWell(
        child: Icon(
          Icons.home,
          size: 18,
        ),
        onTap: () {
          stateProvider.pop(0);
        },
      ));
    for (var i = 0; i < stateProvider.state.breadCrumbTitles.length; i++) {
      wList.add(
        InkWell(
          child: Text(' > ' + stateProvider.state.breadCrumbTitles[i]),
          onTap: () {
            stateProvider.pop(i + 1);
          },
        ),
      );
    }
    return wList;
  }
}
