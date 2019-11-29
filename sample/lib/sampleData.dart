import 'package:flutter/material.dart';
import 'package:power_chart/power_chart.dart';

class DataModel {
  final double domainValue;
  final double rangeValue;
  final bool isHightlighted;
  DataModel(this.domainValue, this.rangeValue, this.isHightlighted);
}

class School {
  final String schoolName;
  final List<Grade> gradeList;
  School(this.schoolName, this.gradeList);
}

class Grade {
  final String gradeName;
  final List<Class> classList;
  Grade(this.gradeName, this.classList);
}

class Class {
  final String className;

  Class(this.className);
}

List<School> get schoolInfo => []
  ..add(School(
      "school1",
      []
        ..add(Grade(
            "grade1",
            []
              ..add(Class("class1"))
              ..add(Class("class2"))
              ..add(Class("class3"))))
        ..add(Grade(
            "grade2",
            []
              ..add(Class("class1"))
              ..add(Class("class2"))
              ..add(Class("class3"))))
        ..add(Grade(
            "grade3",
            []
              ..add(Class("class1"))
              ..add(Class("class2"))
              ..add(Class("class3"))))
        ..add(Grade(
            "grade4",
            []
              ..add(Class("class1"))
              ..add(Class("class2"))
              ..add(Class("class3"))))
        ..add(Grade(
            "grade5",
            []
              ..add(Class("class1"))
              ..add(Class("class2"))
              ..add(Class("class3"))))))
  ..add(School(
      "school2",
      []
        ..add(Grade(
            "grade1",
            []
              ..add(Class("class1"))
              ..add(Class("class2"))
              ..add(Class("class3"))))
        ..add(Grade(
            "grade2",
            []
              ..add(Class("class1"))
              ..add(Class("class2"))
              ..add(Class("class3"))))
        ..add(Grade(
            "grade3",
            []
              ..add(Class("class1"))
              ..add(Class("class2"))
              ..add(Class("class3"))))
        ..add(Grade(
            "grade4",
            []
              ..add(Class("class1"))
              ..add(Class("class2"))
              ..add(Class("class3"))))
        ..add(Grade(
            "grade5",
            []
              ..add(Class("class1"))
              ..add(Class("class2"))
              ..add(Class("class3"))))));

List<Graph> get sampleLineGraph => []..add(Graph.spline(
    PowerChartSeries<School, String, int>.local(
      schoolInfo,
      (s) => s.schoolName,
      (s) => s.gradeList.length,
    ),
    name: "school",
    spot: Spot(showSpots: true, marker: SPOT_SYMBOL.circle),
    area: Area(showArea: false, color: Colors.redAccent, opacity: 1)
  ).drilldown(Graph.spline(
    PowerChartSeries<Grade, String, int>.from(
      (s) {
        if (s == "school1") {
          return List<Grade>()
            ..add(Grade("grade1", []..add(Class("class3"))))
            ..add(Grade(
                "grade2",
                []
                  ..add(Class("class1"))
                  ..add(Class("class2"))
                  ..add(Class("class3"))
                  ..add(Class("class4"))))
            ..add(
                Grade("grade3", []..add(Class("class1"))..add(Class("class3"))))
            ..add(Grade(
                "grade4",
                []
                  ..add(Class("class1"))
                  ..add(Class("class2"))
                  ..add(Class("class3"))
                  ..add(Class("class4"))
                  ..add(Class("class5"))));
        } else {
          return List<Grade>()
            ..add(Grade("grade1", []..add(Class("class3"))))
            ..add(Grade(
                "grade2",
                []
                  ..add(Class("class1"))
                  ..add(Class("class3"))
                  ..add(Class("class4"))))
            ..add(
                Grade("grade3", []..add(Class("class1"))..add(Class("class3"))))
            ..add(Grade(
                "grade4", []..add(Class("class4"))..add(Class("class5"))));
        }
      },
      (s) => s.gradeName,
      (s) => s.classList.length,
    ),
    name: "sample1",
    spot: Spot(showSpots: true, marker: SPOT_SYMBOL.circle),
    area: Area(showArea: true, color: Colors.redAccent, opacity: 1)
  )));
// ..add(
//   Graph.spline(
//       PowerChartData<DataModel, double, double>.local(
//         data2,
//         (s) => s.domainValue,
//         (s) => s.rangeValue,
//       ),
//       name: "sample2",
//       area: Area(showArea: true, color: Colors.yellowAccent, opacity: 0.5)),
// );

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
      DataModel(2, 2, false),
      DataModel(3, 3, false),
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
