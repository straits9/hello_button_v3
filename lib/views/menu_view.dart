import 'package:flutter/material.dart';

class MenuView extends StatelessWidget {
  const MenuView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('메뉴 페이지'),
          ],
        ),
      ),
    );
  }
}