import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hello_button_v3/helpers/aes_helper.dart';

class HelloButtonView extends StatefulWidget {
  const HelloButtonView({Key? key}) : super(key: key);

  @override
  State<HelloButtonView> createState() => _HelloButtonViewState();
}

class _HelloButtonViewState extends State<HelloButtonView> {
  late String? codeStr;
  late String? mac;
  final int ts = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();

    codeStr = Get.parameters['code'];
    mac = _decodeParam(codeStr);
    print('mac: $mac');

    html.window.onBeforeUnload.listen((event) async {
      print('leave current page');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(codeStr == null ? '' : codeStr!),
      ),
    );
  }

  String? _decodeParam(String? param) {
    if (param == null) return null;
    if (param == 'develop') {
      param = AesHelper.enc('${ts.toString()} 00:00:00:00:00:12');
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        Get.offNamed('/hb/$param');
      });
    }

    // decode 진행
    try {
      return AesHelper.extractPayload(param).split(' ')[1];
    } catch (e) {
      return null;
    }
  }
}
