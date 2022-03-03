import 'package:flutter/material.dart';

class UnknownView extends StatelessWidget {
  String msg;
  UnknownView(this.msg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Error:'),
            Text(msg),
          ],
        ),
      ),
    );
  }
}
