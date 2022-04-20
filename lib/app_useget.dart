import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_button_v3/views/hellobutton_view.dart';
import 'package:hello_button_v3/views/top_view.dart';
import 'package:hello_button_v3/views/unknown_view.dart';

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
        textTheme: GoogleFonts.notoSansGothicTextTheme(),
        //primarySwatch: Colors.blue,
        //appBarTheme: const AppBarTheme(
        //  //backwardsCompatibility: false,
        //  systemOverlayStyle: SystemUiOverlayStyle.dark,
        //),
      ),
      initialRoute: '/admin',
      getPages: [
        GetPage(
            name: '/admin',
            page: () => TopView(),
            transition: Transition.fadeIn),
        // GetPage(name: '/splash', page: () => SplashView()),
        // TODO: /hb/test 경우 응답을 하지 않음.
        //GetPage(
        //    name: '/hb',
        //    // page: () => ButtonView(),
        //    page: () => HelloButtonView(),
        //    transition: Transition.noTransition),
        GetPage(
            name: '/hb/:code',
            // page: () => ButtonView(),
            page: () => HelloButtonView(),
            transition: Transition.noTransition),
        GetPage(
            name: '/menu/:store',
            page: () => UnknownView('not supported'),
            transition: Transition.noTransition),
      ],
      // GetX의 unknown router에 문제가 있음. initalRoute를 '/'로 설정할 경우 unknownRoute가 작동하지 않음
      unknownRoute: GetPage(name: '/404', page: () => UnknownView('Error')),
      // GetX의 onUnknownRoute는 작동하지 않음
      onUnknownRoute: (settings) {
        print('on unknown');
        return MaterialPageRoute(builder: (_) => UnknownView('msg1'));
      },
    );
  }

  Route<dynamic>? UnknownRoute(settings) {
    print('unknown routing:');
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => UnknownView('Unknwon'),
    );
  }
}
