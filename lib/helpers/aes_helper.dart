import 'package:encrypt/encrypt.dart' as encrypt_pack;

import '/config.dart';

// AES key size
const KEY_SIZE = 32; // 32 byte key for AES-256
const ITERATION_COUNT = 1000;

class AesHelper {
  static String extractPayload(String code) {
    encrypt_pack.IV ivObj = encrypt_pack.IV.fromUtf8(AppConfig.iv);
    encrypt_pack.Key keyObj = encrypt_pack.Key.fromUtf8(AppConfig.key);

    final encrypter = encrypt_pack.Encrypter(
        encrypt_pack.AES(keyObj, mode: encrypt_pack.AESMode.cbc));
    final decrypted =
        encrypter.decrypt(encrypt_pack.Encrypted.fromBase16(code), iv: ivObj);
    return decrypted;
  }

  static String enc(String payload) {
    encrypt_pack.IV ivObj = encrypt_pack.IV.fromUtf8(AppConfig.iv);
    encrypt_pack.Key keyObj = encrypt_pack.Key.fromUtf8(AppConfig.key);

    final encrypter = encrypt_pack.Encrypter(
        encrypt_pack.AES(keyObj, mode: encrypt_pack.AESMode.cbc));

    final encrypted = encrypter.encrypt(payload, iv: ivObj);
    return encrypted.base16;
  }
}
