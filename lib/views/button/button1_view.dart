import 'dart:convert';

import 'package:dio/dio.dart';
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
    var bodyJson = jsonEncode({ "mac": "00:00:00:00:00:12" });
    try {
      var response = await client.post(
          Uri.parse('https://p38zin8y5g.execute-api.ap-northeast-2.amazonaws.comdev/api/echo'),
          headers: {
            // "Content-Type": "application/json; charset=UTF-8",
            "Accept": "application/json",
            "Access-Control-Allow-Origin": "*",
          },
          body: bodyJson);
      decodedResp =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return Site.fromJson(decodedResp['store']);
    } catch (e) {
      print('error: $e');
    } finally {
      print(decodedResp);
      client.close();
    }
  }
  // Future<Site?> fetechSiteInfo() async {
  //   var dio = Dio();
  //   var decodedResp;
  //   var bodyJson = {'mac': '00:00:00:00:00:12'};
  //   try {
  //     var response = await dio.post(
  //         'https://p38zin8y5g.execute-api.ap-northeast-2.amazonaws.com/dev/api/echo',
  //         data: bodyJson);
  //     print(response);
  //     decodedResp =
  //         jsonDecode(utf8.decode(response.data)) as Map<String, dynamic>;
  //     return Site.fromJson(decodedResp['store']);
  //   } catch (e) {
  //     print('error: $e');
  //   } finally {
  //     print(decodedResp);
  //     dio.close();
  //   }
  // }

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
