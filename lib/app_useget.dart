import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'views/top_view.dart';
import 'views/button_view.dart';
import 'views/menu_view.dart';

class MypGetApp extends StatefulWidget {
  final bool isTestMode;
  final String? initialRoute;
  const MypGetApp({
    Key? key,
    this.isTestMode = false,
    this.initialRoute,
  }) : super(key: key);

  @override
  _MypGetAppState createState() => _MypGetAppState();
}

class _MypGetAppState extends State<MypGetApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hello Button',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => TopView()),
        // GetPage(name: '/splash', page: () => SplashView()),
        // TODO: /hb/test 경우 응답을 하지 않음.
        GetPage(name: '/hb/:code', page: () => const ButtonView()),
        GetPage(name: '/menu/:store', page: () => const MenuView()),
      ],
    );
  }
}