import 'package:get_storage/get_storage.dart';
import 'package:hello_button_v3/models/user.dart';

enum CacheManagerKey { TOKEN, USER }

mixin CacheManager {
  Future<bool> saveToken(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.TOKEN.toString(), token);
    return true;
  }

  Future<bool> saveUser(User user) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.USER.toString(), user.toJson());
    return true;
  }

  String? getToken() {
    final box = GetStorage();
    return box.read(CacheManagerKey.TOKEN.toString());
  }

  User? getUser() {
    final box = GetStorage();
    Map<String, dynamic>? json = box.read(CacheManagerKey.USER.toString());
    User user;
    if (json == null) return null;
    try {
      user = User.fromJson(json);
    } catch (e) {
      return null;
    }
    return user;
    // return User.fromJson(box.read(CacheManagerKey.USER.toString()));
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.TOKEN.toString());
  }

  Future<void> removeUser() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.USER.toString());
  }
}
