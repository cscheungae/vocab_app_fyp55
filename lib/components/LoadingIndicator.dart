import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              child: SpinKitFadingCube(
                color: Theme.of(context).accentColor,
                size: 50.0,
              ),
              width: 100,
              height: 100,
            ),
          )
        ],
      ),
    ]);
  }
}
