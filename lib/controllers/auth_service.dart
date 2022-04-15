import 'package:hello_button_v3/models/user.dart';

// ref: https://github.com/vince-nyanga/flutter_getx_authentication/blob/main/src/lib/features/authentication/authentication_service.dart
class AuthService {
  static Future<User> fakeSignIn(String username, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    String roleStr = 'Role.' + username;
    Role role = stringToRole(roleStr);
    if (role == Role.none || role == Role.staff) {
      throw AuthenticationException(message: 'Not valid user');
    }
    String? siteId =
        (role == Role.manager || role == Role.captain) ? password : null;
    // if (siteId == null) {
    //   throw AuthenticationException(
    //       message: 'There\'s some problem user and site');
    // }
    return User(
      username: username,
      name: 'Test',
      role: role,
      token: 'test token',
      siteId: siteId,
    );
  }

  static Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException({this.message = 'Unknown error occured. '});
}
