import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hello_button_v3/controllers/auth_controller.dart';
import 'package:hello_button_v3/services/global_service.dart';
import 'package:hello_button_v3/views/buttongrid_view.dart';
import 'package:hello_button_v3/views/login_view.dart';
import 'package:hello_button_v3/views/waiting_view.dart';

class TopView extends StatelessWidget {
  TopView({Key? key}) : super(key: key);
  final GlobalService _global = GlobalService();
  final AuthController _auth = Get.put(AuthController());

  // 초기 login check
  Future<void> initializeSettings() async {
    _auth.checkLoginStatus();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    print('get version: ${_global.version}');

    return FutureBuilder(
      future: initializeSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // login check를 진행중이면 circular progress 진행
          return const WaitingView();
        } else {
          if (snapshot.hasError) {
            return page(context);
          }
          return Obx(() {
            // login 상태에 따른 분기
            return _auth.isLogged.value
                ? const ButtonGridView()
                : const LoginView();
          });
        }
      },
    );
  }

  // 특수 case에 대한 표시 widget
  Widget page(context) {
    final AuthController _auth = Get.find();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              // passing parameter with arguments
              // onTap: () => Navigator.pushNamed(context, '/menu',
              //     arguments: {'store': '10'}),

              // passing parameter with query string
              onTap: () => {_auth.logout()},
              child: const Text('헬로 버튼'),
            ),
            Text('v${_global.version} (${_global.build})'),
          ],
        ),
      ),
    );
  }
}
