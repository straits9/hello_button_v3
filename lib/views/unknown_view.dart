import 'package:flutter/material.dart';

class UnknownView extends StatelessWidget {
  String? msg;
  int code;
  UnknownView(this.msg, {this.code = 404});

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    String desc = code >= 500
        ? 'There is an error while processing. please contact system administrator with above error code.'
        : 'The requested URL ${Uri.base.path.toString()} was not founded this server.';
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(0.1 * w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/images/bottom2.png'),
            const SizedBox(height: 40),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: '$code. ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: msg),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(desc),
          ],
        ),
      ),
    );
  }
}
