import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:encrypt/encrypt.dart' as EncryptPack;
import 'package:crypto/crypto.dart' as CryptoPack;
import 'dart:convert' as ConvertPack;

class ButtonView extends StatelessWidget {
  const ButtonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Text('button view'),
            Text('${AesHelper.enc('1646139849460 E2:5A:F4:49:F4:19')}'),
            Text(': ${AesHelper.extractPayload(Get.parameters['code']!)}'),
          ],
        ),
      ),
    );
  }
}

// AES key size
const KEY_SIZE = 32; // 32 byte key for AES-256
const ITERATION_COUNT = 1000;

class AesHelper {
  static String extractPayload(String payload) {
    String strKey = 'Z9HF6BED46L1D3O3C3DEBE8U26T74FNY';
    String strIv = 'hEl0loF1aCt3oRy3';

    //var iv = CryptoPack.sha256
    //    .convert(ConvertPack.utf8.encode(strIv))
    //    .toString()
    //    .substring(0, 16);
    //var key = CryptoPack.sha256
    //    .convert(ConvertPack.utf8.encode(strKey))
    //    .toString()
    //    .substring(0, 32);
    EncryptPack.IV ivObj = EncryptPack.IV.fromUtf8(strIv);
    EncryptPack.Key keyObj = EncryptPack.Key.fromUtf8(strKey);

    final encrypter = EncryptPack.Encrypter(
        EncryptPack.AES(keyObj, mode: EncryptPack.AESMode.cbc));
    var payloadUtf8 = hexDecode(payload).toString();
    print('payload: $payload, $payloadUtf8');
    //String firstBase64Decoding =
    //    String.fromCharCodes(ConvertPack.hex.decode(payload));
    //String ttt = String.fromCharCodes(ConvertPack.utf8.decode(payload))
    //final decrypted = encrypter.decrypt(
    //    EncryptPack.Encrypted.fromBase64(firstBase64Decoding),
    //    iv: ivObj);
    final decrypted = encrypter
        .decrypt(EncryptPack.Encrypted.fromUtf8(payloadUtf8), iv: ivObj);
    return decrypted;
    //return '';
  }

  static String enc(String payload) {
    String strKey = 'Z9HF6BED46L1D3O3C3DEBE8U26T74FNY';
    String strIv = 'hEl0loF1aCt3oRy3';

    //var iv = CryptoPack.sha256
    //    .convert(ConvertPack.utf8.encode(strIv))
    //    .toString()
    //    .substring(0, 16);
    //var key = CryptoPack.sha256
    //    .convert(ConvertPack.utf8.encode(strKey))
    //    .toString()
    //    .substring(0, 32);
    EncryptPack.IV ivObj = EncryptPack.IV.fromUtf8(strIv);
    EncryptPack.Key keyObj = EncryptPack.Key.fromUtf8(strKey);

    final encrypter = EncryptPack.Encrypter(
        EncryptPack.AES(keyObj, mode: EncryptPack.AESMode.cbc));

    final encrypted = encrypter.encrypt(payload, iv: ivObj);
    print(encrypted.bytes);
    return encrypted.bytes.fold('',
        (value, element) => value + element.toRadixString(16).padLeft(2, '0'));
  }

  //static const CBC_MODE = "CBC";

  //static Uint8List deriveKey(dynamic password,
  //    {String salt = '',
  //    int iterationCount = ITERATION_COUNT,
  //    int derivedKeyLength = KEY_SIZE}) {
  //  if (password == null || password.isEpmpty) {
  //    throw ArgumentError('password must not be empty');
  //  }

  //  if (password is String) {
  //    password = createUint8ListFromString(password);
  //  }
  //}

  //static String decrypt(String password, String ciphertext,
  //    {String mode = CBC_MODE}) {
  //  Uint8List derivedKey = deriveLey(password);
  //}
}

Uint8List createUint8ListFromString(String s) {
  var ret = Uint8List(s.length);
  for (var i = 0; i < s.length; i++) {
    ret[i] = s.codeUnitAt(i);
  }
  return ret;
}

Uint8List hexDecode(String str) {
  var bytes = Uint8List(str.length ~/ 2);
  var destinationIndex = 0;
  for (var i = 0; i < str.length - 1; i += 2) {
    var firstDigit = digitForCodeUnit(str.codeUnits, i);
    var secondDigit = digitForCodeUnit(str.codeUnits, i + 1);
    bytes[destinationIndex++] = 16 * firstDigit + secondDigit;
  }
  return bytes;
}

const int $0 = 0x30;
const int $a = 0x61;
const int $f = 0xff;

int digitForCodeUnit(List<int> codeUnits, int index) {
  var codeUnit = codeUnits[index];
  var digit = $0 ^ codeUnit;
  if (digit <= 9) {
    if (digit >= 0) return digit;
  } else {
    var letter = 0x20 | codeUnit;
    if ($a <= letter && letter <= $f) return letter - $a + 10;
  }

  throw FormatException(
      'Invalid hexadicimal code unit '
      'U+${codeUnit.toRadixString(16).padLeft(4, '0')}.',
      codeUnits,
      index);
}
