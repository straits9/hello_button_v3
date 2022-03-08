import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/helpers/aes_helper.dart';

class ButtonView extends StatefulWidget {
  const ButtonView({Key? key}) : super(key: key);

  @override
  State<ButtonView> createState() => _ButtonViewState();
}

class _ButtonViewState extends State<ButtonView> {
  String? codeStr = Get.parameters['code'];
  late int ts;
  late String payload = '';

  @override
  void initState() {
    if (codeStr == null || codeStr == 'test') {
      // get current timestamp
      ts = DateTime.now().millisecondsSinceEpoch;
      codeStr = '${ts.toString()} E2:5A:F4:49:F4:19';
    }

    try {
      payload = AesHelper.extractPayload(codeStr!);
    } catch (e) {
      print('decryption error $e');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Text('button view'),
            Text('code: $codeStr'),
            Text('payload: $payload'),
          ],
        ),
      ),
    );
  }
}

