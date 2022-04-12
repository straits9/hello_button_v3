import 'package:get/get.dart';
import 'package:hello_button_v3/services/cache_service.dart';

class AuthController extends GetxController with CacheManager {
  final isLogged = false.obs;

  void logout() {
    isLogged.value = false;
    removeToken();
  }

  void login(String? token) async {
    isLogged.value = true;
    await saveToken(token);
  }

  bool checkLoginStatus() {
    final token = getToken();
    if (token != null) {
      isLogged.value = true;
    }
    return isLogged.value;
  }
}
