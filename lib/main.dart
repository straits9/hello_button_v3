import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import './app_useget.dart';
import 'package:hello_button_v3/services/global_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  // Do something when app faced an error on release
  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
  };

  await initServices();
  runApp(const MypGetApp());
}

Future<void> initServices() async {
  final GlobalService _global = GlobalService();
  final info = await PackageInfo.fromPlatform();
  String stage = const String.fromEnvironment('stage', defaultValue: 'prod');

  _global.version = info.version;
  _global.build = info.buildNumber;
  _global.stage = stage;
  print(_global);
}
