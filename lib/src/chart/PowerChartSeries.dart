typedef NormalizeFn<T, N> = N Function(T);
typedef DomainFn<T, D> = D Function(T);
typedef RangeFn<T, R> = R Function(T);
typedef GetDataFn<T> = T Function(String);

class PowerChartSeries<T, D extends Comparable, R extends Comparable> {
  List<T> _seriesList;
  double _minDoamin = 0;
  double _maxDomain = 0;
  double _minRange = 0;
  double _maxRange = 0;
  Type domainDataType;
  Type rangeDataType;
  final DomainFn<T, D> domainFn;
  final RangeFn<T, R> rangeFn;
  final GetDataFn<List<T>> getDataFn;

  List<PowerChartPoint> pointList;

  Map<Type, NormalizeFn> normalizeFnMap = {
    DateTime: (a) => a.millisecondsSinceEpoch.toDouble(),
    int: (a) => a.toDouble(),
    double: (a) => a,
    String: (a) => a,
  };

  List<T> get seriesList => _seriesList;
  double get minSeriesDoamin => _minDoamin;
  double get maxSeriesDomain => _maxDomain;
  double get minSeriesRange => _minRange;
  double get maxSeriesRange => _maxRange;

  PowerChartSeries.from(this.getDataFn, this.domainFn, this.rangeFn);

  PowerChartSeries.local(List<T> dataList, this.domainFn, this.rangeFn)
      : this.getDataFn = null {
    _seriesList = dataList;
    init();
  }

  void initData(String label) {
    _seriesList = getDataFn(label);
    init();
  }

  void init() {
    pointList = _covertToStandardPowerChartData(this._seriesList);
    this.pointList.sort((a, b) => a.x.compareTo(b.x));
    _minDoamin = this.pointList.first.x;
    _maxDomain = this.pointList.last.x;
    _minRange = this.pointList[0].y;
    _maxRange = this.pointList[1].y;

    if (_minRange > _maxRange) {
      double tmp = _minRange;
      _minRange = _maxRange;
      _maxRange = tmp;
    }

    int i;
    for (i = 2; i < this.pointList.length - 1; i += 2) {
      if (this.pointList[i].y < this.pointList[i + 1].y) {
        if (this.pointList[i].y < _minRange) {
          _minRange = this.pointList[i].y;
        }
        if (this.pointList[i + 1].y > _maxRange) {
          _maxRange = this.pointList[i + 1].y;
        }
      } else {
        if (this.pointList[i + 1].y < _minRange) {
          _minRange = this.pointList[i + 1].y;
        }
        if (this.pointList[i].y > _maxRange) {
          _maxRange = this.pointList[i].y;
        }
      }
    }

    if (i != this.pointList.length) {
      if (this.pointList[i].y < _minRange) {
        _minRange = this.pointList[i].y;
      } else if (this.pointList[i].y > _maxRange) {
        _maxRange = this.pointList[i].y;
      }
    }
  }

  List<PowerChartPoint> _covertToStandardPowerChartData(
    List<T> dataList,
  ) {
    List<PowerChartPoint> list = new List<PowerChartPoint>();
    domainDataType = domainFn(dataList.last).runtimeType;
    rangeDataType = rangeFn(dataList.last).runtimeType;
    assert(rangeDataType != String,
        "rangDataType can only be number or datatime.");

    for (var i = 0; i < dataList.length; i++) {
      if (domainDataType == String) {
        list.add(
          PowerChartPoint(
              i.toDouble(), normalizeFnMap[rangeDataType](rangeFn(dataList[i])),
              xLabel: normalizeFnMap[domainDataType](domainFn(dataList[i]))),
        );
      } else {
        list.add(
          PowerChartPoint(normalizeFnMap[domainDataType](domainFn(dataList[i])),
              normalizeFnMap[rangeDataType](rangeFn(dataList[i]))),
        );
      }
    }
    return list;
  }
}

class PowerChartPoint {
  double x;
  double y;
  String xLabel;
  double pixelX;
  double pixelY;

  PowerChartPoint(double x, double y, {String xLabel}) {
    this.x = x;
    this.y = y;
    this.xLabel = xLabel;
  }
}
