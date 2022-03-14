import 'package:flutter/material.dart';
import 'pages.dart';

class AppParser extends RouteInformationParser<PageConfiguration> {
  AppParser() {
    print('appParser (constructor)');
  }

  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    print('appParser (parse): $routeInformation');
    final uri = Uri.parse(routeInformation.location!);
    final state = routeInformation.state;
    print('appParser (parse): uri = $uri, state = $state');
    print('appParser (parse): uri segment = ${uri.pathSegments}');
    if (uri.pathSegments.isEmpty) {
      return SplashPageConfig;
    }

    final path = '/' + uri.pathSegments.first;
    switch (path) {
      case TopPath:
        return TopPageConfig;
      case SplashPath:
        return SplashPageConfig;
      case MenuPath:
        return MenuPageConfig;
      case ButtonPath:
        return ButtonPageConfig;
      default:
        return SplashPageConfig;
    }
  }

  @override
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    print('appParser (restore): conf=$configuration');
    switch (configuration.uiPage) {
      case Pages.Top:
        return const RouteInformation(location: TopPath);
      case Pages.Splash:
        return const RouteInformation(location: SplashPath);
      case Pages.Menu:
        return const RouteInformation(location: MenuPath);
      case Pages.Button:
        return const RouteInformation(location: ButtonPath);
      default:
        return const RouteInformation(location: SplashPath);
    }
  }
}
