/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/components/ErrorAlert.dart';
import 'package:vocab_app_fyp55/components/Label.dart';
import 'package:vocab_app_fyp55/components/LoadingIndicator.dart';
import 'package:vocab_app_fyp55/model/stat.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';

class SimpleTimeSeriesChart extends StatefulWidget {
  @override
  _SimpleTimeSeriesChartState createState() => _SimpleTimeSeriesChartState();
}

class _SimpleTimeSeriesChartState extends State<SimpleTimeSeriesChart> {
  Future<List<Stat>> statistics;
  /// for Selection Callback Example Interactions
  DateTime _time;
  Map<String, num> _measures;

  @override
  void initState() {
    super.initState();
    statistics = _getStatistics();
  }

  Future<List<Stat>> _getStatistics() async {
    return await DatabaseProvider.instance.readAllStat();
  }

  List<charts.Series<TimeSeriesCount, DateTime>> _createSeries(List<Stat> statistics) {
    List<TimeSeriesCount> learningData = [];
    List<TimeSeriesCount> trackingData = [];
    List<TimeSeriesCount> maturedData = [];

    statistics.forEach((stat) {
      DateTime logDate = stat.logDate;
      learningData.add(new TimeSeriesCount(new DateTime(logDate.year, logDate.month, logDate.day), stat.learningCount));
      trackingData.add(new TimeSeriesCount(new DateTime(logDate.year, logDate.month, logDate.day), stat.trackingCount));
      maturedData.add(new TimeSeriesCount(new DateTime(logDate.year, logDate.month, logDate.day), stat.maturedCount));
    });

    return [
      new charts.Series<TimeSeriesCount, DateTime>(
        id: 'Learning',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesCount timeSeriesCount, _) => timeSeriesCount.time,
        measureFn: (TimeSeriesCount timeSeriesCount, _) => timeSeriesCount.count,
        data: learningData,
      ),
      new charts.Series<TimeSeriesCount, DateTime>(
        id: 'Tracking',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesCount timeSeriesCount, _) => timeSeriesCount.time,
        measureFn: (TimeSeriesCount timeSeriesCount, _) => timeSeriesCount.count,
        data: trackingData,
      ),
      new charts.Series<TimeSeriesCount, DateTime>(
        id: 'Matured',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (TimeSeriesCount timeSeriesCount, _) => timeSeriesCount.time,
        measureFn: (TimeSeriesCount timeSeriesCount, _) => timeSeriesCount.count,
        data: maturedData,
      )
    ];
  }

  void _onSelectionChanged(charts.SelectionModel model) {
//    print("_onSelectionChanged()");

    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.count;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Stat>>(
      future: statistics,
      builder: (BuildContext context, AsyncSnapshot<List<Stat>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          widget = Card(
//            color: Colors.black,
            elevation: 8.0,
            child: Container(
              padding: EdgeInsets.fromLTRB(10,20,10,10),
              height: 400,
              child: Column(
                children: [
                  Flexible(
                    flex: 12,
                    child: charts.TimeSeriesChart(
                      _createSeries(snapshot.data),
                      animate: true,
                        domainAxis: new charts.DateTimeAxisSpec(
                          renderSpec: new charts.SmallTickRendererSpec(
                              labelStyle: new charts.TextStyleSpec(
                                  color: charts.MaterialPalette.white)
                          )
                        ),
                      primaryMeasureAxis: new charts.NumericAxisSpec(
                          renderSpec: new charts.SmallTickRendererSpec(
                              labelStyle: new charts.TextStyleSpec(
                                  color: charts.MaterialPalette.white)
                          )
                      ),
                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                      selectionModels: [
                        new charts.SelectionModelConfig(
                          type: charts.SelectionModelType.info,
                          changedListener: _onSelectionChanged,
                        )
                      ],
                      behaviors: [
                        new charts.SeriesLegend(),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 3),
                      child: _time != null ? Text('${_time.day.toString()}-${_time.month.toString()}-${_time.year.toString()}'): Text(""),
                    ),
                  ),
                  Flexible(
                    flex: 0,
                    child: Column(
                      children: _measures != null ? _measures.entries.map((entry) => new Text('${entry.key}: ${entry.value}')).toList() : [],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) widget = new ErrorAlert("SimpleTimeSeriesChart");
        else widget = new LoadingIndicator();
        return widget;
      }
    );
  }
}

/// Project time series data type.
class TimeSeriesCount {
  final DateTime time;
  final int count;

  TimeSeriesCount(this.time, this.count);
}