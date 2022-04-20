import 'package:encrypt/encrypt.dart' as encrypt_pack;

String key = 'Z9HF6BED46L1D3O3C3DEBE8U26T74FNY';
String iv = 'hEl0loF1aCt3oRy3';

String extractPayload(String code) {
  encrypt_pack.IV ivObj = encrypt_pack.IV.fromUtf8(iv);
  encrypt_pack.Key keyObj = encrypt_pack.Key.fromUtf8(key);

  code = code.toLowerCase();
  final encrypter = encrypt_pack.Encrypter(
      encrypt_pack.AES(keyObj, mode: encrypt_pack.AESMode.cbc));
  final decrypted =
      encrypter.decrypt(encrypt_pack.Encrypted.fromBase16(code), iv: ivObj);
  return decrypted;
}

String enc(String payload) {
  encrypt_pack.IV ivObj = encrypt_pack.IV.fromUtf8(iv);
  encrypt_pack.Key keyObj = encrypt_pack.Key.fromUtf8(key);

  // payload = payload.toLowerCase();
  final encrypter = encrypt_pack.Encrypter(
      encrypt_pack.AES(keyObj, mode: encrypt_pack.AESMode.cbc));

  final encrypted = encrypter.encrypt(payload, iv: ivObj);
  return encrypted.base16;
}

main(List<String> args) {
  print('dart $args');

  if (args[0] == 'enc') {
    var etemp = enc(args[1]);
    print(etemp);
    var temp = extractPayload(etemp);
    print(temp);
    print(args[1] == temp);
  } else if (args[0] == 'dec') {
    var temp = extractPayload(args[1]);
    print(temp);
    var etemp = enc(temp);
    print(etemp);
    print(args[1] == etemp);
  } else {
    extractPayload(args[0]);
  }
}
