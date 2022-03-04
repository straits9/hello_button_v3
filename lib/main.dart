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
      onGenerateRoute: AppRouter.onGenerateRoute,

      // use onGenerateRoute:
      // onGenerateRoute: (settings) {
      //   final parts = settings.name?.split('?');
      //   // only arguments support
      //   // final args = settings.arguments as Map<String, dynamic>?;

      //   // argument and query string supports
      //   final args = settings.arguments != null
      //       ? settings.arguments as Map<String, dynamic>?
      //       : parts?.length == 2
      //           ? Uri.splitQueryString(parts![1])
      //           : null;
      //   print('args: $parts, $args');

      //   switch (parts?[0]) {
      //     case '/':
      //       return MaterialPageRoute(
      //         settings: settings, // pass settings to display nav-address bar
      //         builder: (_) => TopView(),
      //       );

      //     case '/menu':
      //       final store = args?['store'] as String?;
      //       return MaterialPageRoute(
      //         settings: settings, // pass settings to display nav-address bar
      //         builder: (_) => MenuView(store: store),
      //       );

      //     default:
      //       return MaterialPageRoute(
      //           builder: (_) =>
      //               UnknownView('unknown route: ${settings.name}'));
      //   }
      // }

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

class AppRouter {
  // helper for
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    print('enter: ${settings.toString()}');
    final PageDef? router = routers.firstWhere((r) {
      print('check page ${settings?.name}');
      var ret = r.matches(settings);
      return ret;
    });
    return router != null
        ? MaterialPageRoute(
            settings: settings, builder: (context) => router.page())
        : MaterialPageRoute(
            settings: settings,
            builder: (_) => UnknownView('unknown route: ${settings.name}'));
  }

  static final List<PageDef> routers = [
    PageDef(name: '/', page: () => TopView()),
    PageDef(name: '/test', page: () => MenuView()),
    PageDef(name: '/123/12', page: () => TopView()),
    PageDef(name: '/menu/:store', page: () => MenuView()),
  ];
}

class PageDef {
  final String name;
  final Widget Function() page;
  PageDef({required this.name, required this.page}) {
    print('name: $name');
    var parts = name.split('/').map((part) {
      print('part name: [$part]');
      if (part == null || part == '') return '';
      if (part[0] == ':') {
        var id = part.substring(1);
        _var.add(id);
        print('variables: $_var');
        // return '(?<$id>[^\\/]+)';
        return '(?<$id>[^/]+)';
      } else {
        return part;
      }
    }).toList();
    print('parts: $parts');
    // _regex = parts.join('\\/');
    _regex = parts.join('/');
    print('skip check');
    _regex = '$_regex\$';
    print('_regex: $_regex');
  }

  final List<String> _var = [];
  late String _regex;

  bool matches(RouteSettings settings) {
    print(
        'page ${settings.name} compare to [$name] with regex string (r\'$_regex\')');
    print('and variables ${_var.toString()}');

    //final re = RegExp(r'${_regex}');
    final re = RegExp(_regex);
    final match = re.firstMatch(settings.name!);
    print(match.toString());
    return match == null ? false : true;
    //return settings.name != null ? settings.name!.startsWith(name) : false;
  }
}

class Path {
  final String pattern;
  final Widget Function(BuildContext, String) builder;
  const Path(this.pattern, this.builder);
  bool matches(RouteSettings settings) {
    return settings.name != null ? settings.name!.startsWith(pattern) : false;
  }
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
