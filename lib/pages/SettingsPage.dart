import "package:flutter/material.dart";
import "../state/SettingsState.dart";
import "package:provider/provider.dart";
import "../res/theme.dart";

class SettingsPage extends StatelessWidget {
  SettingsState settings;
  String title;

  SettingsPage({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    settings = Provider.of<SettingsState>(context);
    // TODO: implement build
    return Theme(
      data: customThemeData,
      child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Column(
            children: <Widget>[
              SwitchListTile(
                title:Text("Turning on Notification?"),
                value: settings.sendNotification,
                onChanged: (isActive) =>
                    settings.setSendNotification = isActive,
              ),
              Slider(
                label:"Volume",
                value: settings.volume,
                onChanged: (vol) => settings.setVolume = vol,
                min: 0,
                max: 1,
              ),
              ListTile(
              title:Text("Font Size"),
              trailing:  
              DropdownButton(
                  onChanged: (val) => settings.setFontSize = val,
                  iconEnabledColor: Colors.blue,
                  value: settings.fontSize,
                  iconSize: 30,
                  items: SettingsState.fontSizeOptions
                      .map((size) => DropdownMenuItem<int>(
                          value: size, child: Text(size.toString())))
                      .toList())
              ),
            ],
          )),
    );
  }
}
