import 'package:flutter/material.dart';
import 'package:power_chart/src/chart/ChartState.dart';

class BreadCrumb extends StatefulWidget {
  @override
  _BreadCrumbState createState() => _BreadCrumbState();
}

class _BreadCrumbState extends State<BreadCrumb> {
  int level;
  ChartState chartState;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: getBreadCrumbs(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (chartState == null) {
      chartState = InheritedChartStateBuilder.of(context);
    }
  }

  List<Widget> getBreadCrumbs() {
    List<Widget> wList = List<Widget>();
    for (var i = 0; i < chartState.breadCrumbTitles.length; i++) {
      wList.add(SizedBox(
        width: 80,
        height: 20,
        child: FlatButton(
          child: Text(chartState.breadCrumbTitles[i]),
          onPressed: () {
            chartState.breadCrumbTitles =
                chartState.breadCrumbTitles.sublist(0, i);
          },
        ),
      ));
      if (i != chartState.breadCrumbTitles.length - 1) {
        wList.add(Text('/'));
      }
    }
    return wList;
  }
}
