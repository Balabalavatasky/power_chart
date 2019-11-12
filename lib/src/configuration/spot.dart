import 'package:power_chart/src/configuration/enum.dart';

class Spot {
  final bool showSpots;
  final SPOT_SYMBOL marker;
  final int spotSize;
  Spot({
    this.showSpots=false,
    this.marker,
    this.spotSize,
  });
}
