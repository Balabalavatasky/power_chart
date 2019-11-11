import 'package:power_chart/power_chart.dart';

class DataModel {
  final double domainValue;
  final double rangeValue;
  final bool isHightlighted;
  DataModel(this.domainValue, this.rangeValue, this.isHightlighted);
}

List<Graph> get sampleLineGraph =>
    []..add(Graph.line(PowerChartData<DataModel, double, double>(
        data, (s) => s.domainValue, (s) => s.rangeValue)));

ChartBorder get sampleBorder => ChartBorder(
      horizontalAxis: ChartAxis(showScale: true, showScaleIndicator: true),
      verticalAxis: ChartAxis(showScale: true, showScaleIndicator: true),
    );
BackgroundGrid get sampleBackgroundGrid =>
    BackgroundGrid(showVerticalGridLine: false, showHorizontalGridLine: false);
Indicator get sampleIndicator => Indicator();

List<DataModel> get data => [
      DataModel(-1, -1, false),
      DataModel(1.0, 1, false),
      DataModel(2.0, 2, false),
      DataModel(3.0, 3, false),
      DataModel(4.0, 4, false),
      DataModel(5.0, 5, false),
      DataModel(6.0, 6, false),
      DataModel(7.0, 7, false),
    ];
