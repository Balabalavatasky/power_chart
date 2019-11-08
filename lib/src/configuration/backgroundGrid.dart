import 'package:flutter/material.dart';

class BackgroundGrid {
  final bool showVerticalGridLine;
  final bool showHorizontalGridLine;
  final Paint verticalGridLinePaint;
  final Paint horizontalGridLinePaint;

  BackgroundGrid(
      {this.showVerticalGridLine=false,
      this.showHorizontalGridLine=false,
      this.verticalGridLinePaint,
      this.horizontalGridLinePaint});
}
