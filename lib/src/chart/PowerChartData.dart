typedef DistanceFn<T> = double Function(T, T);
typedef NormalizeFn<T> = double Function(T);
typedef DomainFn<T, D> = D Function(T);
typedef RangeFn<T, R> = R Function(T);

class PowerChartData<T, D extends Comparable, R extends Comparable> {
  final List<T> dataList;
  final DomainFn<T, D> domainFn;
  final RangeFn<T, R> rangeFn;

  List<PowerChartPoint> pointList;

  double minDoamin = 0;
  double maxDomain = 0;
  double minRange = 0;
  double maxRange = 0;
  Map<Type, NormalizeFn> normalizeFnMap = {
    DateTime: (a) => a.millisecondsSinceEpoch.toDouble(),
    int: (a) => a.toDouble(),
    double: (a) => a,
  };

  PowerChartData(this.dataList, this.domainFn, this.rangeFn,
      {Function hightlightedFn}) {
    pointList = _covertToStandardPowerChartData(this.dataList,
        hightlightedFn: hightlightedFn);

    this.pointList.sort((a, b) => a.x.compareTo(b.x));
    minDoamin = this.pointList.first.x;
    maxDomain = this.pointList.last.x;
    minRange = this.pointList[0].y;
    maxRange = this.pointList[1].y;

    if (minRange > maxRange) {
      double tmp = minRange;
      minRange = maxRange;
      maxRange = tmp;
    }

    int i;
    for (i = 2; i < this.pointList.length - 1; i += 2) {
      if (this.pointList[i].y < this.pointList[i + 1].y) {
        if (this.pointList[i].y < minRange) {
          minRange = this.pointList[i].y;
        }
        if (this.pointList[i + 1].y > maxRange) {
          maxRange = this.pointList[i + 1].y;
        }
      } else {
        if (this.pointList[i + 1].y < minRange) {
          minRange = this.pointList[i + 1].y;
        }
        if (this.pointList[i].y > maxRange) {
          maxRange = this.pointList[i].y;
        }
      }
    }

    if (i != this.pointList.length) {
      if (this.pointList[i].y < minRange) {
        minRange = this.pointList[i].y;
      } else if (this.pointList[i].y > maxRange) {
        maxRange = this.pointList[i].y;
      }
    }
  }

  List<PowerChartPoint> _covertToStandardPowerChartData(List<T> dataList,
      {Function hightlightedFn}) {
    List<PowerChartPoint> list = new List<PowerChartPoint>();
    Type domainDataType = domainFn(dataList.last).runtimeType;
    Type rangeDataType = rangeFn(dataList.last).runtimeType;

    for (var i = 0; i < dataList.length; i++) {
      list.add(
        PowerChartPoint(normalizeFnMap[domainDataType](domainFn(dataList[i])),
            normalizeFnMap[rangeDataType](rangeFn(dataList[i])),
            isHighted:
                hightlightedFn == null ? false : hightlightedFn(dataList[i])),
      );
    }
    return list;
  }
}

class PowerChartPoint {
  double x;
  double y;
  double coordinateX;
  double coordinateY;
  bool isHighted = false;

  PowerChartPoint(num x, num y, {bool isHighted = false}) {
    this.x = x;
    this.y = y;
    this.isHighted = isHighted;
  }
}
