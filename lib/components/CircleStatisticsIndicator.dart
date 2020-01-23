
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../res/theme.dart' as CustomTheme;

class CircleStatisticsIndicator extends StatelessWidget {

  /// value displayed in the presentation layer
  final int wordsLearnt;

  /// percentage determining the circle indicator in the presentation layer
  final double percentage;


  /// Constructor of CircleStatisticsIndicator
  /// Optional:
  /// [wordsLearnt] - default to 0
  /// [percentage]  - default to 0.3
  CircleStatisticsIndicator({ this.wordsLearnt = 0, this.percentage = 0.3, });


  @override
  Widget build(BuildContext context) {
    return Padding(
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
                          percent: this.percentage,
                          center: Container(
                            padding: const EdgeInsets.all(38.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  this.wordsLearnt.toString(),
                                  style: TextStyle(
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                                      "learned",
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
                            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(40.0),),
                            textColor: CustomTheme.WHITE,
                            color: CustomTheme.GREEN,
                            child: Text( 'More', style: TextStyle(fontSize: 14.0)),
                            onPressed:(){
                                //Do Something
                            }
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          );
  }
}