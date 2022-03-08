import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:encrypt/encrypt.dart' as EncryptPack;
import 'package:crypto/crypto.dart' as CryptoPack;
import 'dart:convert' as ConvertPack;

import 'package:hello_button_v3/config.dart';

class ButtonView extends StatefulWidget {
  const ButtonView({Key? key}) : super(key: key);

  @override
  State<ButtonView> createState() => _ButtonViewState();
}

class _ButtonViewState extends State<ButtonView> {
  String? codeStr = Get.parameters['code'];
  late int ts;
  late String payload = '';

  @override
  void initState() {
    if (codeStr == null || codeStr == 'test') {
      // get current timestamp
      ts = DateTime.now().millisecondsSinceEpoch;
      codeStr = '${ts.toString()} E2:5A:F4:49:F4:19';
    }

    try {
      payload = AesHelper.extractPayload(codeStr!);
    } catch (e) {
      print('decryption error $e');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Text('button view'),
            Text('code: $codeStr'),
            Text('payload: $payload'),
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
  static String extractPayload(String code) {
    EncryptPack.IV ivObj = EncryptPack.IV.fromUtf8(AppConfig.iv);
    EncryptPack.Key keyObj = EncryptPack.Key.fromUtf8(AppConfig.key);

    final encrypter = EncryptPack.Encrypter(
        EncryptPack.AES(keyObj, mode: EncryptPack.AESMode.cbc));
    final decrypted =
        encrypter.decrypt(EncryptPack.Encrypted.fromBase16(code), iv: ivObj);
    return decrypted;
  }

  static String enc(String payload) {
    EncryptPack.IV ivObj = EncryptPack.IV.fromUtf8(AppConfig.iv);
    EncryptPack.Key keyObj = EncryptPack.Key.fromUtf8(AppConfig.key);

    final encrypter = EncryptPack.Encrypter(
        EncryptPack.AES(keyObj, mode: EncryptPack.AESMode.cbc));

    final encrypted = encrypter.encrypt(payload, iv: ivObj);
    return encrypted.base16;
  }
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
