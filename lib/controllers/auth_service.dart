import 'package:get/get.dart';

// ref: https://github.com/vince-nyanga/flutter_getx_authentication/blob/main/src/lib/features/authentication/authentication_service.dart

abstract class AuthService extends GetxService {
  Future<User?> getCurrentUser();
  Future<User> signIn(String username, String password);
  Future<void> signOut();
}

class FakeAuthService extends AuthService {
  @override
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<User> signIn(String username, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    String lusername = username.toLowerCase();
    String? storeno = null;
    switch (lusername) {
      case 'manager':
        storeno = password;
      case 'admin':
        break;
    }

    } else if (username.)
  }
}

class AuthenticationExeption implements Exception {
  final String message;
  AuthenticationExeption({this.message = 'Unknown error occured. '});
}
