import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vocab_app_fyp55/model/ResponseFormat/StatResponse.dart';
import 'package:vocab_app_fyp55/model/stat.dart';
import 'package:vocab_app_fyp55/model/user.dart';
import 'package:vocab_app_fyp55/services/FetchStats.dart';
import 'package:vocab_app_fyp55/state/DatabaseNotifier.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  /// A list of Stats object
  Future<List<StatResponse>> statsList;
  User currentUser;

  String sortByParams = "trackingCount";

  Future<List<StatResponse>> initStatsList(
      {String sortByParams = "learningCount"}) async {

    this.sortByParams = sortByParams;

    return FetchStats.requestRankStats(sortByParam: sortByParams);
  }

  @override
  void initState() {
    print("Stat initState()");
    super.initState();
    getCurrentUser().then((user) {
      currentUser = user;
      syncServerStat(uid: user.uid).whenComplete(() => statsList = initStatsList(sortByParams: this.sortByParams));
    });
  }

  Future<User> getCurrentUser() async {
    List<User> users = await Provider.of<DatabaseNotifier>(context, listen: false).dbHelper.readAllUser();
    if(users != null) return users[0];
    else return null;
  }


  Future<void> syncServerStat({int uid}) async {
    Stat stat = await Provider.of<DatabaseNotifier>(context, listen: false).dbHelper.readLatestStat();
    if(stat != null) {
      await FetchStats.pushStats(uid: uid, sid: stat.sid, logDate: stat.logDate, learningCount: stat.learningCount, matureCount: stat.maturedCount, trackingCount: stat.trackingCount);
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StatResponse>>(
        future: statsList,
        builder: (BuildContext context,
            AsyncSnapshot<List<StatResponse>> snapshot) {
//          print("snapshot: " + snapshot.toString());
          Widget widget;
          if (snapshot.hasData) {
//            print("hasData");
            /// flutter table
            List<DataRow> dataRows = [];
            snapshot.data.forEach((StatResponse statResponse) {
              {
                Color textColor = Colors.white70;
                if ( currentUser != null && statResponse.uid == currentUser.uid) {
                  textColor = Theme.of(context).accentColor;
                }
                dataRows.add(DataRow(cells: [
                  DataCell(Text(statResponse.ranking.toString(), style: TextStyle(color: textColor),)),
                  DataCell(Text(statResponse.username, style: TextStyle(color: textColor))),
                  DataCell(Text(statResponse.trackingCount.toString(), style: TextStyle(color: textColor))),
                  DataCell(Text(statResponse.learningCount.toString(), style: TextStyle(color: textColor))),
                  DataCell(Text(statResponse.matureCount.toString(), style: TextStyle(color: textColor))),
                ]));
              }
            });

            widget = DataTable(
              columnSpacing: 10,
              columns: [
                DataColumn(label: Text('Rank')),
                DataColumn(label: Text('Name')),
                DataColumn(
                    numeric: true,
                    label: Text('Tracking', style: TextStyle(color: this.sortByParams == "trackingCount" ? Theme.of(context).accentColor : Colors.white70),),
                    onSort: (_i, _b) {
                      setState(() {
                        if(this.sortByParams != 'trackingCount')
                          statsList = initStatsList(sortByParams: "trackingCount");
                      });
                    }),
                DataColumn(
                    numeric: true,
                    label: Text('Learning', style: TextStyle(color: this.sortByParams == "learningCount" ? Theme.of(context).accentColor : Colors.white70),),
                    onSort: (_i, _b) {
                      setState(() {
                        if(this.sortByParams != 'learningCount')
                          statsList = initStatsList(sortByParams: "learningCount");
                      });
                    }),
                DataColumn(
                    numeric: true,
                    label: Text('Matured', style: TextStyle(color: this.sortByParams == "matureCount" ? Theme.of(context).accentColor : Colors.white70),),
                    onSort: (_i, _b) {
                      setState(() {
                        if(this.sortByParams != 'matureCount')
                          statsList = initStatsList(sortByParams: "matureCount");
                      });
                    }),
              ],
              rows: dataRows,
            );
          } else if (snapshot.hasError) {
//            print("hasError");
            widget = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Error in loading ranking",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                )
              ],
            );
          } else {
//            print("loading screen");
            widget =
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                          width: 60,
                          height: 60,
                        ),
                      )
                    ],
                  ),
                ]);
          }
          return widget;
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose Leaderboard");
  }
}
