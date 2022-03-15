import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:hello_button_v3/models/site.dart';

class RemoteServices {
  static var client = http.Client();

  static Future<Site?> fetchButtons(String mac) async {
    var response = await client.post(
        Uri.parse(
            'https://p38zin8y5g.execute-api.ap-northeast-2.amazonaws.com/dev/api/buttons'),
        body: json.encode({'mac': mac}));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print('http response: $jsonString');
      return null;
      //return Site.fromJson(json.decode(jsonString) as Map<String, dynamic>);
    } else {
      print('http err resp: $response');
      return null;
    }
  }
}
