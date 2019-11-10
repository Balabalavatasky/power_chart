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
      left: ChartAxis(),
      bottom: ChartAxis(),
    );
BackgroundGrid get sampleBackgroundGrid=>BackgroundGrid();
Indicator get sampleIndicator=>Indicator();

List<DataModel> get data => [
      DataModel(1.0, 4.6, false),
      DataModel(2.0, 3.1, false),
      DataModel(3.0, 2.76, false),
      DataModel(4.0, 8.1, false),
      DataModel(5.0, 9.6, false),
      DataModel(6.0, 2.32, false),
      DataModel(7.0, 4.77, false),
    ];
