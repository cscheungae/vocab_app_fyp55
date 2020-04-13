import 'package:charts_flutter/flutter.dart' as charts;
import 'package:vocab_app_fyp55/components/Leaderboard.dart';
import 'package:vocab_app_fyp55/components/SimpleTimeSeriesChart.dart';
import '../res/theme.dart' as CustomTheme;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StatisticsPage extends StatefulWidget {
  StatisticsPage({Key key}) : super(key: key);

  @override
  _StatisticsPage createState() => _StatisticsPage();
}

class _StatisticsPage extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {

  /// Tabs
  final List<Tab> tabs = <Tab>[
    Tab(
      text: 'Personal',
    ),
    Tab(
      text: 'Leaderboard',
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: [
//            Container(child: Text("hello")),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: SimpleTimeSeriesChart(),
            ),
            Leaderboard()
          ],
        ),
      ),
    );
  }
}
