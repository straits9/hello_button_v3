import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello_button_v3/controllers/auth_controller.dart';
import 'package:hello_button_v3/services/global_service.dart';
import 'package:hello_button_v3/widgets/button_grid_widget.dart';
import 'package:hello_button_v3/widgets/login_widget.dart';
import 'package:hello_button_v3/widgets/waiting_widget.dart';

// ref: https://github.com/ozkayas/auth_manager/blob/master/lib/login/login_view.dart

class TopView extends StatelessWidget {
  TopView({Key? key}) : super(key: key);
  final GlobalService _global = GlobalService();
  final AuthController _auth = Get.put(AuthController());

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
          return const WaitingView();
          // } else if (snapshot.connectionState == ConnectionState.done) {
        } else {
          if (snapshot.hasError) {
            return page(context);
          }
          return Obx(() {
            return _auth.isLogged.value
                ? const ButtonGridView()
                // ? GraphQLProvider(
                //     client: GraphqlConfig.initClient(),
                //     child: page(context),
                //   )
                : const LoginView();
          });
        }
      },
    );
  }

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
