import 'package:flutter/material.dart';
import 'package:hello_button_v3/router/pages.dart';

enum PageState {
  none,
  addPage,
  addAll,
  addWidget,
  pop,
  replace,
  replaceAll,
}

class PageAction {
  PageState? state;
  PageConfiguration? page;
  List<PageConfiguration>? pages;
  Widget? widget;

  PageAction({
    this.state,
    this.page,
    this.pages,
    this.widget,
  });

  @override
  String toString() => 'pageAction: $state ($page)';
}

class AppState extends ChangeNotifier {
  AppState() {}

  bool _splashFinished = false;
  bool get splashFinished => _splashFinished;

  PageAction _currentAction = PageAction();
  PageAction get currentAction => _currentAction;
  set currentAction(PageAction action) {
    _currentAction = action;
    notifyListeners();
  }

  void resetCurrentAction() {
    _currentAction = PageAction();
  }

  void setSplashFinished() {
    _splashFinished = true;
    _currentAction =
        PageAction(state: PageState.replaceAll, page: TopPageConfig);
    notifyListeners();
  }
}
