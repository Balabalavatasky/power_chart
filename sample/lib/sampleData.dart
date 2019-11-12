import 'package:power_chart/power_chart.dart';

class DataModel {
  final double domainValue;
  final double rangeValue;
  final bool isHightlighted;
  DataModel(this.domainValue, this.rangeValue, this.isHightlighted);
}

List<Graph> get sampleLineGraph => []
  ..add(
    Graph.line(
        PowerChartData<DataModel, double, double>(
          data1,
          (s) => s.domainValue,
          (s) => s.rangeValue,
        ),
        name: "sample1"),
  )
  ..add(Graph.line(
      PowerChartData<DataModel, double, double>(
        data2,
        (s) => s.domainValue,
        (s) => s.rangeValue,
      ),
      name: "sample2"));

ChartBorder get sampleBorder => ChartBorder(
      showBootom: true,
      showLeft: true,
      horizontalAxis: ChartAxis(showScale: true, showScaleIndicator: true),
      verticalAxis: ChartAxis(showScale: true, showScaleIndicator: true),
    );
BackgroundGrid get sampleBackgroundGrid =>
    BackgroundGrid(showVerticalGridLine: false, showHorizontalGridLine: false);
Indicator get sampleIndicator => Indicator();

List<DataModel> get data1 => [
      DataModel(-1, 2, false),
      DataModel(1.0, 1, false),
      DataModel(2.0, 2, false),
      DataModel(3.0, 3, false),
      DataModel(4.0, 4, false),
      DataModel(5.0, 5, false),
      DataModel(6.0, 6, false),
      DataModel(7.0, 4.6, false),
    ];

List<DataModel> get data2 => [
      DataModel(0, 1.2, false),
      DataModel(1.0, 2.3, false),
      DataModel(2.0, 3.4, false),
      DataModel(3.0, 2.5, false),
      DataModel(4.0, 4, false),
      DataModel(5.0, 6.1, false),
      DataModel(6.0, 2.5, false),
      DataModel(7.0, 3.8, false),
    ];
