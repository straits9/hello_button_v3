import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hello_button_v3/app_state.dart';
import 'package:hello_button_v3/router/pages.dart';
import 'package:hello_button_v3/views/menu_view.dart';
import 'package:hello_button_v3/views/splash_view.dart';
import 'package:hello_button_v3/views/top_view.dart';

class AppRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfiguration> {
  final List<Page> _pages = [];
  // AppBackButtonDispatcher backButtonDispatcher;

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppState appState;

  AppRouterDelegate(this.appState) : navigatorKey = GlobalKey() {
    print('appDelegate (constructor):');
    appState.addListener(() {
      notifyListeners();
    });
  }

  /// Getter for a list that cannot be changed
  List<MaterialPage> get pages => List.unmodifiable(_pages);

  /// Number of pages function
  int numPages() => _pages.length;

  @override
  PageConfiguration get currentConfiguration =>
      _pages.last.arguments as PageConfiguration;

  @override
  Widget build(BuildContext context) {
    print('appDelegate (build):');
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: buildPages(),
    );
  }

  bool _onPopPage(Route<dynamic> route, result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    if (canPop()) {
      pop();
      return true;
    } else {
      return false;
    }
  }

  void _removePage(MaterialPage page) {
    if (page != null) {
      _pages.remove(page);
    }
  }

  void pop() {
    if (canPop()) {
      _removePage(_pages.last as MaterialPage);
    }
  }

  bool canPop() {
    return _pages.length > 1;
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _removePage(_pages.last as MaterialPage);
      return Future.value(true);
    }
    return Future.value(false);
  }

  MaterialPage _createPage(Widget child, PageConfiguration pageConfig) {
    return MaterialPage(
        child: child,
        key: ValueKey(pageConfig.key),
        name: pageConfig.path,
        arguments: pageConfig);
  }

  void _addPageData(Widget child, PageConfiguration pageConfig) {
    _pages.add(
      _createPage(child, pageConfig),
    );
  }

  void addPage(PageConfiguration pageConfig) {
    print('appDelegate (addpage): $pageConfig');
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            pageConfig.uiPage;
    if (shouldAddPage) {
      switch (pageConfig.uiPage) {
        case Pages.Top:
          _addPageData(TopView(), TopPageConfig);
          break;
        case Pages.Splash:
          _addPageData(const SplashView(), SplashPageConfig);
          break;
        case Pages.Menu:
          if (pageConfig.currentPageAction != null) {
            _addPageData(const MenuView(), MenuPageConfig);
          }
          break;
        case Pages.Button:
          if (pageConfig.currentPageAction != null) {
            _addPageData(pageConfig.currentPageAction!.widget!, pageConfig);
          }
          break;
        default:
          break;
      }
    }
  }

  void replace(PageConfiguration newRoute) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    addPage(newRoute);
  }

  void setPath(List<MaterialPage> path) {
    _pages.clear();
    _pages.addAll(path);
  }

  void replaceAll(PageConfiguration newRoute) {
    print('appDelegate (replaceAll): $newRoute');
    setNewRoutePath(newRoute);
  }

  void push(PageConfiguration newRoute) {
    addPage(newRoute);
  }

  void pushWidget(Widget child, PageConfiguration newRoute) {
    _addPageData(child, newRoute);
  }

  void addAll(List<PageConfiguration> routes) {
    _pages.clear();
    routes.forEach((route) {
      addPage(route);
    });
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            configuration.uiPage;
    if (shouldAddPage) {
      _pages.clear();
      addPage(configuration);
    }
    return SynchronousFuture(null);
  }

  void _setPageAction(PageAction action) {
    print('appDeleage (_setPageAction): $action');
    switch (action.page?.uiPage) {
      case Pages.Top:
        TopPageConfig.currentPageAction = action;
        break;
      case Pages.Splash:
        SplashPageConfig.currentPageAction = action;
        break;
      case Pages.Menu:
        MenuPageConfig.currentPageAction = action;
        break;
      case Pages.Button:
        ButtonPageConfig.currentPageAction = action;
        break;
      default:
        break;
    }
  }

  List<Page> buildPages() {
    print(
        'appDelegate (build pages): currentAction = ${appState.currentAction}');
    if (!appState.splashFinished) {
      replaceAll(SplashPageConfig);
    } else {
      switch (appState.currentAction.state!) {
        case PageState.none:
          break;
        case PageState.addPage:
          _setPageAction(appState.currentAction);
          addPage(appState.currentAction.page!);
          break;
        case PageState.pop:
          pop();
          break;
        case PageState.replace:
          _setPageAction(appState.currentAction);
          replace(appState.currentAction.page!);
          break;
        case PageState.replaceAll:
          _setPageAction(appState.currentAction);
          replaceAll(appState.currentAction.page!);
          break;
        case PageState.addWidget:
          _setPageAction(appState.currentAction);
          pushWidget(
              appState.currentAction.widget!, appState.currentAction.page!);
          break;
        case PageState.addAll:
          addAll(appState.currentAction.pages!);
          break;
      }
    }
    appState.resetCurrentAction();
    return List.of(_pages);
  }

  void parseRoute(Uri uri) {
    print('appDelegate (parseRoute): uri = $uri');
    if (uri.pathSegments.isEmpty) {
      setNewRoutePath(SplashPageConfig);
      return;
    }

    // Handle navapp://deeplinks/menu/#
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == 'menu') {
        pushWidget(MenuView(store: uri.pathSegments[1]), MenuPageConfig);
      }
    } else if (uri.pathSegments.length == 1) {
      final path = uri.pathSegments[0];
      switch (path) {
        case 'top':
          replaceAll(TopPageConfig);
          break;
        case 'splash':
          replaceAll(SplashPageConfig);
          break;
        // case 'menu':
        //   replaceAll(MenuPageConfig);
        //   break;
        case 'button':
          replaceAll(ButtonPageConfig);
          break;
      }
    }
  }
}
