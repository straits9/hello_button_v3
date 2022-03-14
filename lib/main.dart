import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './app_useget.dart';
import 'package:hello_button_v3/services/global_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  // Do something when app faced an error on release
  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
    // if (!kReleaseMode) {
    //   exit(1);
    // }
  };

  // rotation to landscape block
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await initServices();
  runApp(const MypGetApp());
}

Future<void> initServices() async {
  final GlobalService _global = GlobalService();
  final info = await PackageInfo.fromPlatform();

  print('version: ${info.version}');
  _global.version = info.version;
  _global.build = info.buildNumber;
}
