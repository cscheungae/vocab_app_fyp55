


import 'package:charts_flutter/flutter.dart' as charts;
import '../res/theme.dart' as CustomTheme;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class StatisticsPage extends StatefulWidget
{
  StatisticsPage( {Key key}) : super(key: key);

  @override 
  _StatisticsPage createState() => _StatisticsPage();
}



class _StatisticsPage extends State<StatisticsPage> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this );
  }


  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context){

    return 
    Scaffold(
      body: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[ 
        SafeArea(
          child: Container(
            alignment: Alignment.centerLeft,
            height: 100,
            width: MediaQuery.of(context).size.width * 0.85,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.transparent,
              tabs: [
                Tab( child: Text(
                  "NET MATURE CARD",
                  maxLines: 3,
                ),),
                Tab( child: Text(
                  "TRACKED WORDS",
                  maxLines: 3,
                ),),
                Tab( child: Text(
                  "LEARNING WORDS",
                  maxLines: 3,
                ),),
              ],
            ),
          ),
        ),


        Container(
          padding: EdgeInsets.all(3),
          height: MediaQuery.of(context).size.height * 0.4,
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              //1st Tab
              Container(
                child: charts.BarChart(
                  [
                    charts.Series(
                      id: "Click",
                      domainFn: (value , _) => "JOJO - " + value.toString(),
                      measureFn: (value , _) => value,
                      colorFn: (value , _) => charts.ColorUtil.fromDartColor(Colors.orange),
                      data: <int>[ 10, 23, 51],
                    ),
                  ],
                  animate: true,
                  //Changing Color of the domain Axis
                  domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.SmallTickRendererSpec(
                    labelStyle: new charts.TextStyleSpec(
                      fontSize: 14,
                      color: charts.ColorUtil.fromDartColor(Colors.white),
                    ),
                  )), 

                ),
              ),
              //2nd Tab
              Icon(Icons.directions_transit),
              //3rd Tab
              Icon(Icons.directions_bike),
            ],
          ),
        ),

        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(2.0),
          child: Text(
            "Learned Words: 10", 
            style: TextStyle(fontSize: 16,),
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(2.0),
          child: Text(
            "Study Time: 100 hours 12 minutes",
            style: TextStyle(fontSize: 16, ),
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(2.0),
          child: Text(
            "Total Vocabulary FlashCard: 10",
            style: TextStyle(fontSize: 16, ),
          ),
        ),

      ],),

    );
  }
}