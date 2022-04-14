import 'package:get/get.dart';
import 'package:hello_button_v3/services/cache_service.dart';

enum Role {
  none,
  user,
  staff,
  manager,
  captain,
  distributor,
  admin,
  system,
}

class AuthController extends GetxController with CacheManager {
  final isLogged = false.obs;
  final username = ''.obs;
  final role = Rx<Role>(Role.none);

  void logout() {
    isLogged.value = false;
    removeToken();
  }

  void login(String? token) async {
    isLogged.value = true;
    await saveToken(token);
  }

  void checkLoginStatus() {
    final token = getToken();
    if (token != null) {
      isLogged.value = true;
    }
  }
}
