import 'package:flutter/material.dart';
import '../res/theme.dart' as CustomTheme;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key key, this.title, this.iconData}) : super(key: key);

  final String title;
  final IconData iconData;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      title: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w400,
        ),
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(iconData),
          onPressed: () => debugPrint("pressed profile icon"),
          tooltip: "user profile",
        ),
      ],
    );
  }
}
