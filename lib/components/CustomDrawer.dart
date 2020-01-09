import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: Column(
          //Settings
          children:[
            AppBar(title: Text("Drawer Navigator"),actionsIconTheme: null,),
            Divider(color:Colors.white24),
            ListTile(title:Text("")),
            ListTile(
              title:Text("Settings"),
              trailing:Icon(Icons.settings),
              onTap: ()=>Navigator.pushNamed(context,"/settings"),
            )
          ],
        ),
    );
  }
}