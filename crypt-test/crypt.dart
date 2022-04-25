import 'package:encrypt/encrypt.dart' as encrypt_pack;

String iv = 'hEl0loF1aCt3oRy3';
String key = 'Z9HF6BED46L1D3O3C3DEBE8U26T74FNY';

String enc(String payload) {
  encrypt_pack.IV ivObj = encrypt_pack.IV.fromUtf8(iv);
  encrypt_pack.Key keyObj = encrypt_pack.Key.fromUtf8(key);

  final encrypter = encrypt_pack.Encrypter(
      encrypt_pack.AES(keyObj, mode: encrypt_pack.AESMode.cbc));

  final encrypted = encrypter.encrypt(payload, iv: ivObj);
  return encrypted.base16;
}

String extractPayload(String code) {
  encrypt_pack.IV ivObj = encrypt_pack.IV.fromUtf8(iv);
  encrypt_pack.Key keyObj = encrypt_pack.Key.fromUtf8(key);
  print(ivObj.toString());

  final encrypter = encrypt_pack.Encrypter(
      encrypt_pack.AES(keyObj, mode: encrypt_pack.AESMode.cbc));
  print(encrypter);
  final encrypted = encrypt_pack.Encrypted.fromBase16(code);
  print(encrypted);
  final decrypted = encrypter.decrypt(encrypted, iv: ivObj);
  return decrypted;
}

String dec(String code) {
  final ivObj = encrypt_pack.IV.fromUtf8(iv);
  final keyObj = encrypt_pack.Key.fromUtf8(key);
  final encrypter = encrypt_pack.Encrypter(encrypt_pack.AES(keyObj, mode: encrypt_pack.AESMode.cbc, padding: null));
  final decrypted = encrypter.decrypt(encrypt_pack.Encrypted.fromBase16(code), iv: ivObj);
  return decrypted;
}

main(List<String> args) {
  print('dart $args');

  if (args[0] == 'enc') {
    var e = enc(args[1]);
    var d = extractPayload(e);
    var d1 = extractPayload(e.toUpperCase());
    print('encrypted: ${e}');
    print('original : ${args[1]}');
    print('decrypted: ${d}');
    print('decrypted: ${d1}');
  } else if (args[0] == 'dec') {
    var temp = dec(args[1]);
    print(temp);
    var etemp = enc(temp);
    print(etemp);
    print(args[1] == etemp);
  } else {
    extractPayload(args[0]);
  }
}
