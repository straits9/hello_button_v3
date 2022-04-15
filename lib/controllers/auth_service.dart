import 'package:get/get.dart';
import 'package:hello_button_v3/controllers/auth_controller.dart';

// ref: https://github.com/vince-nyanga/flutter_getx_authentication/blob/main/src/lib/features/authentication/authentication_service.dart
class AuthService {
  static Future<User> signIn(String username, String password) async {
    Future.delayed(const Duration(seconds: 2));
    return User(username: username, name: 'Test', role: Role.manager);
  }

  static Future<void> signOut() async {
    Future.delayed(const Duration(seconds: 1));
  }
}

class User {
  String username;
  String name;
  Role role;

  User({
    required this.username,
    required this.name,
    required this.role,
  });

  @override
  String toString() => 'User { name: $name, id: $username, role: $role }';
}

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException({this.message = 'Unknown error occured. '});
}
