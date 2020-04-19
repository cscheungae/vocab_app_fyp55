
import 'package:flutter/material.dart';
import 'dart:math';

class LeaderBoardPage extends StatefulWidget {
  @override
  _LeaderBoardPage createState() => _LeaderBoardPage();
}

class _LeaderBoardPage extends State<LeaderBoardPage> with SingleTickerProviderStateMixin {

  //Table List
  List<TableRow> _tableRows;


  @override
  void initState() {
    super.initState();
    _tableRows = buildRandomRows();
  }
  
  @override
  void dispose() {
    super.dispose();
  }


  TableRow buildTableRow(int ranking, String username, int v1, int v2, int v3){
    String rankText = ( ranking < 10 ) ? "0" + ranking.toString() : ranking.toString();
    return 
    TableRow( children: [
      Text(rankText), 
      Icon(Icons.person),
      Text(username),
      Text(v1.toString()),
      Text(v2.toString()),
      Text(v3.toString()),
    ]);
  }



  List<TableRow> buildRandomRows(){
    Random rng = new Random();
    List<TableRow> result = [];
    for ( int i = 0; i < 10; i++ )
      result.add( buildTableRow( i, "Peter", rng.nextInt(100), rng.nextInt(100), rng.nextInt(100)));
    return result;
  }



  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
      ),

      body: Table(
        children: _tableRows,
      ),
    );
  }
}