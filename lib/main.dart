import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:get/get.dart';
import 'package:hello_button_v3/services/global_service.dart';
import 'package:hello_button_v3/views/button_view.dart';
import 'package:hello_button_v3/views/menu_view.dart';
import 'package:hello_button_v3/views/top_view.dart';
import 'package:hello_button_v3/views/unknown_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();
  runApp(const MyApp());
}

Future<void> initServices() async {
  final GlobalService _global = GlobalService();
  final info = await PackageInfo.fromPlatform();

  print('version: ${info.version}');
  _global.version = info.version;
  _global.build = info.buildNumber;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return GetMaterialApp(
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // initialRoute: '/',
        // home: TopView(),
        // onGenerateRoute: RouteConfiguration.onGenerateRoute,

        // use onGenerateRoute:
        onGenerateRoute: (settings) {
          final parts = settings.name?.split('?');
          // only arguments support
          // final args = settings.arguments as Map<String, dynamic>?;

          // argument and query string supports
          final args = settings.arguments != null
              ? settings.arguments as Map<String, dynamic>?
              : parts?.length == 2
                  ? Uri.splitQueryString(parts![1])
                  : null;
          print('args: $parts, $args');

          switch (parts?[0]) {
            case '/':
              return MaterialPageRoute(
                settings: settings, // pass settings to display nav-address bar
                builder: (_) => TopView(),
              );

            case '/menu':
              final store = args?['store'] as String?;
              return MaterialPageRoute(
                settings: settings, // pass settings to display nav-address bar
                builder: (_) => MenuView(store: store),
              );

            default:
              return MaterialPageRoute(
                  builder: (_) =>
                      UnknownView('unknown route: ${settings.name}'));
          }
        }

        // getx route
        // getPages: [
        //   GetPage(
        //     name: '/',
        //     page: () => TopView(),
        //   ),
        //   GetPage(name: '/test', page: () => TopView()),
        //   GetPage(name: '/hb/:code', page: () => const ButtonView()),
        //   GetPage(name: '/hm/:store', page: () => const MenuView()),
        // ],
        );
  }
}

abstract class Router {
  // derived classes implement these methods
  bool matches(RouteSettings settings);
  MaterialPageRoute route(RouteSettings settings);

  // helper for
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final router =
        routers.firstWhere((r) => r.maches(settings), orElse: () => null);
    return router != null
        ? router.route(settings)
        : MaterialPageRoute(
            settings: settings,
            builder: (_) => UnknownView('unknown route: ${settings.name}'));
  }

  static final routers = [];
}

class Path {
  final String pattern;
  final Widget Function(BuildContext, String) builder;
  const Path(this.pattern, this.builder);
}

class RouteConfiguration {
  static List<Path> paths = [
    Path(r'^/', (context, match) => TopView()),
    Path(r'^/test', (context, match) => MenuView()),
    // Path('/', (context, match) => TopView()),
    // Path('/test', (context, match) => MenuView()),
  ];

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    print(settings);
    for (Path path in paths) {
      print('test ${settings.name} with ${path.pattern}');
      final regExpPattern = RegExp(path.pattern);
      print('regexp: $regExpPattern');
      if (regExpPattern.hasMatch(settings.name!)) {
        final firstMatch = regExpPattern.firstMatch(settings.name!);
        print('firstMatch: $firstMatch');
        final match =
            (firstMatch?.groupCount == 1) ? firstMatch?.group(1) : null;
        print('match: $match');
        return MaterialPageRoute<void>(
          builder: (context) => path.builder(context, match!),
          settings: settings,
        );
      }
    }

    return null;
  }
}
