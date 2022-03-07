import 'package:hello_button_v3/app_state.dart';

const String TopPath = '/';
const String MenuPath = '/menu';
const String SplashPath = '/splash';
const String ButtonPath = '/hb';

enum Pages {
  Top,
  Menu,
  Splash,
  Button,
}

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;
  PageAction? currentPageAction;

  PageConfiguration({
    required this.key,
    required this.path,
    required this.uiPage,
    this.currentPageAction,
  }) {
    print('pageconf: $key');
  }

  @override
  String toString() => 'page($key, $path, $uiPage)';
}

PageConfiguration TopPageConfig = PageConfiguration(
    key: 'Top', path: TopPath, uiPage: Pages.Top, currentPageAction: null);
PageConfiguration MenuPageConfig = PageConfiguration(
    key: 'Menu', path: MenuPath, uiPage: Pages.Menu, currentPageAction: null);
PageConfiguration SplashPageConfig = PageConfiguration(
    key: 'Splash',
    path: SplashPath,
    uiPage: Pages.Splash,
    currentPageAction: null);
PageConfiguration ButtonPageConfig = PageConfiguration(
    key: 'Button',
    path: ButtonPath,
    uiPage: Pages.Button,
    currentPageAction: null);
