import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hello_button_v3/models/site.dart';

class Button1View extends StatefulWidget {
  const Button1View({Key? key}) : super(key: key);

  @override
  _Button1ViewState createState() => _Button1ViewState();
}

class _Button1ViewState extends State<Button1View> {
  late Future<Site?> site;

  Future<Site?> fetechSiteInfo() async {
    var client = http.Client();
    var decodedResp;
    var bodyJson = jsonEncode({"mac": "00:00:00:00:00:12"});
    try {
      var response = await client.post(
          Uri.parse(
              'https://p38zin8y5g.execute-api.ap-northeast-2.amazonaws.com/dev/api/buttons'),
          headers: {
            "Content-Type": "application/json",
          },
          body: bodyJson);
      if (response.statusCode == 200) {
        print(response.body);
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return Site.fromJson(jsonResponse);
      } else {
        return null;
      }
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  void initState() {
    site = fetechSiteInfo();
    print(site.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('ttt'),
      ),
    );
  }
}
