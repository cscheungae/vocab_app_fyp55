


import 'package:charts_flutter/flutter.dart' as charts;
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
    appBar: TabBar(
        controller: _tabController,
        labelStyle:  TextStyle( fontWeight: FontWeight.w400, color: Colors.white ),
        tabs: [
          Tab(text: "NET MATURE CARDS",),
          Tab(text: "TRACKED WORDS",),
          Tab(text: "LEARNING WORDS"),
        ],
    ),
      


      body: TabBarView(
        controller: _tabController,
        children: [
          
          //1st Tab
          Container(
            padding: EdgeInsets.all(32.0),
            height: 200,
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

      //bottomNavigationBar: CustomBottomNavBar(),
      //drawer: CustomDrawer(),
    );
  }
}