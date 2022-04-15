import 'package:get/get.dart';
import 'package:hello_button_v3/controllers/auth_service.dart';
import 'package:hello_button_v3/models/user.dart';
import 'package:hello_button_v3/services/cache_service.dart';

class AuthController extends GetxController with CacheManager {
  final isLogged = false.obs;
  final username = ''.obs;
  final role = Rx<Role>(Role.none);

  User? get user => getUser();

  void logout() {
    isLogged.value = false;
    removeUser();
  }

  Future<void> login(String username, String password) async {
    final user = await AuthService.fakeSignIn(username, password);
    await saveUser(user);
    isLogged.value = true;
  }

  void checkLoginStatus() {
    final user = getUser();
    if (user?.token != null) {
      isLogged.value = true;
    }
  }
}
