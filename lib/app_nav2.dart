import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_button_v3/app_state.dart';
import 'package:hello_button_v3/router/delegate.dart';
import 'package:hello_button_v3/router/dispatcher.dart';
import 'package:hello_button_v3/router/pages.dart';
import 'package:hello_button_v3/router/parser.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

class MyNav2App extends StatefulWidget {
  const MyNav2App({ Key? key }) : super(key: key);

  @override
  _MyNav2AppState createState() => _MyNav2AppState();
}

class _MyNav2AppState extends State<MyNav2App> with SingleTickerProviderStateMixin {
  final appState = AppState();
  late final AppRouterDelegate delegate;
  final parser = AppParser();
  late final AppBackButtonDispatcher backButtonDispatcher;

  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;
  StreamSubscription? _sub;

  late StreamSubscription _linkSubscription;

  _MyNav2AppState() {
    delegate = AppRouterDelegate(appState);
    delegate.setNewRoutePath(SplashPageConfig);
    backButtonDispatcher = AppBackButtonDispatcher(delegate);
  }

  @override
  void initState() {
    super.initState();
    // _handleIncomingLinks();
    // _handleInitialUri();
  }

  @override
  void dispose() {
    if (_linkSubscription != null) _linkSubscription.cancel();
    super.dispose();
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        setState(() {
          _latestUri = uri;
          _err = null;
          delegate.parseRoute(uri!);
        });
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialUri() async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a weidget that will be disposed of (ex. a navigation route change).
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      print('_handleInitialUri called');

      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
        }
        if (!mounted) return;
        setState(() => _initialUri = uri);
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        print('malformed initial uri');
        setState(() {
          _err = err;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //return GetMaterialApp(
    return ChangeNotifierProvider<AppState>(
      create: (_) => appState,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Hello Button',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        backButtonDispatcher: backButtonDispatcher,
        routerDelegate: delegate,
        routeInformationParser: parser,
      ),
    );
  }
}