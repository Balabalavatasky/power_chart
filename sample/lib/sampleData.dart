import 'package:power_chart/power_chart.dart';

class DataModel {
  final double domainValue;
  final double rangeValue;
  final bool isHightlighted;
  DataModel(this.domainValue, this.rangeValue, this.isHightlighted);
}

List<Graph> get sampleLineGraph => []
  ..add(Graph.spline(
      PowerChartData<DataModel, double, double>(
        data1,
        (s) => s.domainValue,
        (s) => s.rangeValue,
      ),
      name: "sample1",
      spot: Spot(showSpots: true, marker: SPOT_SYMBOL.circle)))
  ..add(Graph.spline(
      PowerChartData<DataModel, double, double>(
        data2,
        (s) => s.domainValue,
        (s) => s.rangeValue,
      ),
      name: "sample2"));

ChartBorder get sampleBorder => ChartBorder(
      showHorizontalAxis: true,
      showVerticalAxis: true,
      horizontalAxis: ChartAxis(showScale: true, showScaleIndicator: true),
      verticalAxis: ChartAxis(showScale: true, showScaleIndicator: true),
    );
BackgroundGrid get sampleBackgroundGrid =>
    BackgroundGrid(showVerticalGridLine: false, showHorizontalGridLine: false);
Indicator get sampleIndicator => Indicator();

List<DataModel> get data1 => [
      DataModel(-1, -1, false),
      DataModel(1.0, 1, false),
      DataModel(2, 1, false),
      DataModel(3, 1, false),
      DataModel(4.0, 4, false),
      DataModel(5.0, 5, false),
      DataModel(6.0, 6, false),
      DataModel(7.0, 7, false),
    ];

List<DataModel> get data2 => [
      DataModel(0, 1.211, false),
      DataModel(1.0, 2.33, false),
      DataModel(2.0, 3.43, false),
      DataModel(3.0, 2.555, false),
      DataModel(4.0, 4, false),
      DataModel(5.0, 6.12, false),
      DataModel(6.0, 2.54, false),
      DataModel(7.0, 3.58, false),
    ];
