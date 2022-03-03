import 'package:flutter/material.dart';

class MenuView extends StatelessWidget {
  final String? store;
  const MenuView({Key? key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('메뉴 페이지 ($store)'),
          ],
        ),
      ),
    );
  }
}
