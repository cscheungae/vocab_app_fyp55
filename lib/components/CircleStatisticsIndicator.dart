import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vocab_app_fyp55/components/ErrorAlert.dart';
import 'package:vocab_app_fyp55/components/LoadingIndicator.dart';
import 'package:vocab_app_fyp55/model/stat.dart';
import 'package:vocab_app_fyp55/pages/StatisticsPage.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';
import '../res/theme.dart' as CustomTheme;
import '../util/Router.dart' as Router;

class CircleStatisticsIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseProvider.instance.readLatestStat(),
      builder: (BuildContext context, AsyncSnapshot<Stat> snapshot) {
//        print("CircularIndicator: " + snapshot.toString());
        Widget widget;
        if (snapshot.hasData) {
          Stat stat = snapshot.data;
          widget = Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  height: 255,
                  color: CustomTheme.BLACK,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8.0),
                    children: <Widget>[
                      Text(
                        "progress".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircularPercentIndicator(
                          radius: 155.0,
                          lineWidth: 8.0,
                          animation: true,
                          percent: (stat.learningCount != 0 &&
                                  stat.trackingCount != 0 &&
                                  (stat.learningCount != null ||
                                      stat.learningCount != null))
                              ? stat.learningCount /
                                  (stat.learningCount + stat.trackingCount)
                              : 0,
                          center: Container(
                            padding: const EdgeInsets.all(38.0),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  (stat.learningCount != null)
                                      ? stat.learningCount.toString()
                                      : '0',
                                  style: TextStyle(
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "words",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                    Text(
                                      "learning",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: CustomTheme.GREEN,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              textColor: CustomTheme.WHITE,
                              color: CustomTheme.GREEN,
                              child: Text('More',
                                  style: TextStyle(fontSize: 14.0)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    Router.AnimatedRoute(
                                        newWidget: new StatisticsPage()));
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              ));
        } else if (snapshot.hasError)
          widget = new ErrorAlert("CircleStatistics");
        else
          widget = new LoadingIndicator();
        return widget;
      },
    );
  }
}
