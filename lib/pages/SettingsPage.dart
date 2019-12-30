import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app_fyp55/bloc/SettingsBloc.dart';
import 'package:vocab_app_fyp55/event/SettingsEvent.dart';
import '../state/SettingsState.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage>{
  SettingsBloc bloc = new SettingsBloc();

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar( title: Text("Setting Page"),),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        bloc: bloc,
        builder: (context, state ){
          return Column(
            children: <Widget>
            [
              SwitchListTile(
                title:Text("Turning on Notification?"),
                value: state.sendNotification,
                onChanged: (isActive) => bloc.add(ToggleNotifications(isActive)),
              ),
              Slider(
                label:"Volume",
                value: state.volume,
                onChanged: (vol) => bloc.add(ChangeVolume(vol)),
                min: 0,
                max: 1,
              ),
              ListTile(
              title:Text("Font Size"),
              trailing:  
              DropdownButton(
                  onChanged: (val) => bloc.add(ChangeFontSize(val)),
                  iconEnabledColor: Colors.blue,
                  value: state.fontSize,
                  iconSize: 30,
                  items: [8, 12, 16, 24, 32, 48]
                      .map((size) => DropdownMenuItem<int>(
                          value: size, child: Text(size.toString())))
                      .toList()),
              ),
            ],
          );
        }
      ),
    );
  }


}




