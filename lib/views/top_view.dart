import 'package:flutter/material.dart';
import 'package:hello_button_v3/services/global_service.dart';

class TopView extends StatelessWidget {
  TopView({Key? key}) : super(key: key);
  GlobalService _global = GlobalService();

  @override
  Widget build(BuildContext context) {
    print('get version: ${_global.version}');

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[const Text('헬로 버튼'), Text('v${_global.version} (${_global.build})')],
        ),
      ),
    );
  }
}
