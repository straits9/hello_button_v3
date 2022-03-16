import 'dart:convert';
import 'package:hello_button_v3/config.dart';
import 'package:hello_button_v3/services/constants/transaction_data.dart';
import 'package:http/http.dart' as http;

import 'package:hello_button_v3/models/site.dart';

class RemoteServices {
  static Uri URL(String uri) => Uri.parse(AppConfig.url_prefix + uri);

  static Future<Site?> fetchButtons(String mac) async {
    var response = await http.post(URL('/dev/api/buttons'),
        body: jsonEncode({'mac': mac}));
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

class NetService {
  static Uri URL(String uri) => Uri.parse(AppConfig.url_prefix + uri);

  static Future fetchJsonData(String path) {
    return http
        .get(URL(path))
        .then((response) =>
            response.statusCode == 200 ? jsonDecode(response.body) : null)
        .catchError((err) => print(err));
  }

  static Future fetchLocalJsonData() async {
    await Future.delayed(const Duration(seconds: 3));
    return jsonDecode(transactionData) as Map<String, dynamic>;
  }

  static Future fetchPostJsonData(String path, dynamic body) {
    return http
        .post(URL(path), body: jsonEncode(body))
        .then((response) =>
            response.statusCode == 200 ? jsonDecode(response.body) : null)
        .catchError((err) => print(err));
  }
}
