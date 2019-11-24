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
    List<Widget> wList = List<Widget>();
    for (var i = 0; i < stateProvider.state.breadCrumbTitles.length; i++) {
      wList.add(SizedBox(
        width: 80,
        height: 20,
        child: FlatButton(
          child: Text(stateProvider.state.breadCrumbTitles[i]),
          onPressed: () {
            stateProvider.pop(i + 1);
          },
        ),
      ));
      if (i != stateProvider.state.breadCrumbTitles.length - 1) {
        wList.add(Text('/'));
      }
    }
    return wList;
  }
}

// class BreadCrumb extends StatefulWidget {
//   @override
//   _BreadCrumbState createState() => _BreadCrumbState();
// }

// class _BreadCrumbState extends State<BreadCrumb> {
//   int level;
//   ChartState chartState;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: getBreadCrumbs(),
//     );
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (chartState == null) {
//       chartState = InheritedChartStateBuilder.of(context);
//     }
//   }

//   List<Widget> getBreadCrumbs() {
//     List<Widget> wList = List<Widget>();
//     for (var i = 0; i < chartState.breadCrumbTitles.length; i++) {
//       wList.add(SizedBox(
//         width: 80,
//         height: 20,
//         child: FlatButton(
//           child: Text(chartState.breadCrumbTitles[i]),
//           onPressed: () {
//             setState(() {
//               chartState.breadCrumbTitles =
//                   chartState.breadCrumbTitles.sublist(0, i + 1);
//             });
//           },
//         ),
//       ));
//       if (i != chartState.breadCrumbTitles.length - 1) {
//         wList.add(Text('/'));
//       }
//     }
//     return wList;
//   }
// }
