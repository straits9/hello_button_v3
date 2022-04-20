import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hello_button_v3/controllers/auth_controller.dart';
import 'package:hello_button_v3/services/global_service.dart';
import 'package:hello_button_v3/views/login_view.dart';
import 'package:hello_button_v3/views/unknown_view.dart';
import 'package:hello_button_v3/views/waiting_view.dart';

//
//  /admin의 기본 페이지
//
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
            print(snapshot.error);
            return UnknownView('Unknown error', code: 500);
          }
          return Obx(() {
            // login 상태에 따른 분기
            return _auth.isLogged.value
                ? UnknownView('not yet implemented', code: 500)
                // ? ButtonGridView(
                //     user: _auth.user,
                //     useSliverHeader: true,
                //   )
                : const LoginView();
          });
        }
      },
    );
  }
}
