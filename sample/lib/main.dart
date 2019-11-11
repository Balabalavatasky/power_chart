import 'package:flutter/material.dart';
import 'package:power_chart/power_chart.dart';
import 'sampleData.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'power chart Demo',
      showPerformanceOverlay: false,
      theme: ThemeData(
        primaryColor: const Color(0xff262545),
        primaryColorDark: const Color(0xff201f39),
      ),
      home: const MyHomePage(title: 'power_chart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 200,
          child: PowerChart(
            sampleLineGraph,
            backgroundColor: Colors.green[100],
            chartBorder: sampleBorder,
            backgroundgrid: sampleBackgroundGrid,
            showIndicators: true,
            indicator: sampleIndicator,
          ),
        ),
      ),
    );
  }
}
