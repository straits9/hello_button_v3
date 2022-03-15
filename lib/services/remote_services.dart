import 'package:http/http.dart' as http;

class RemoteServices {
  static var client = http.Client();

  static Future<Map<String, dynamic>> fetchButtons(String mac) async {
    var response = await client.post(
        Uri.parse(
            'https://p38zin8y5g.execute-api.ap-northeast-2.amazonaws.com/dev/api/buttons'),
        body: {mac: mac});
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return
    }
  }
}
