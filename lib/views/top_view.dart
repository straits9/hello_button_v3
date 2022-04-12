import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hello_button_v3/controllers/auth_controller.dart';
import 'package:hello_button_v3/services/global_service.dart';
import 'package:hello_button_v3/services/graphql.dart';
import 'package:hello_button_v3/widgets/login_widget.dart';

// ref: https://github.com/ozkayas/auth_manager/blob/master/lib/login/login_view.dart

class TopView extends StatelessWidget {
  TopView({Key? key}) : super(key: key);
  final GlobalService _global = GlobalService();
  final AuthController _auth = Get.put(AuthController());

  Future<bool> initializeSettings() async {
    bool logged = _auth.checkLoginStatus();
    await Future.delayed(const Duration(milliseconds: 500));
    return Future.value(logged);
  }

  @override
  Widget build(BuildContext context) {
    print('get version: ${_global.version}');

    return FutureBuilder(
      future: initializeSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingView();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return page(context);
          } else if (snapshot.hasData) {
            return Obx(() {
              return _auth.isLogged.value
                  ? GraphQLProvider(
                      client: GraphqlConfig.initClient(),
                      child: page(context),
                    )
                  : const LoginView();
            });
          }
        }
        return const Text('Empty data');
      },
    );
  }

  Widget page(context) {
    final AuthController _auth = Get.find();

    return Query(
      options: QueryOptions(
        document: gql(Queries.site),
        variables: const {'siteid': 35},
      ),
      builder: (result, {refetch, fetchMore}) {
        if (result.hasException) return Text(result.exception.toString());
        if (result.isLoading) return waitingView();

        print(result);
        return Scaffold(
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
      },
    );
  }

  Scaffold waitingView() {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
