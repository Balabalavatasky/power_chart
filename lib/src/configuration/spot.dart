import 'package:flutter/material.dart';
import 'package:power_chart/src/configuration/enum.dart';

class Spot {
  bool showSpots;
  SPOT_SYMBOL marker;
  double spotSize;
  Color color;
  Spot({
    this.showSpots = false,
    this.marker = SPOT_SYMBOL.circle,
    this.spotSize = 5,
    this.color,
  });
}
