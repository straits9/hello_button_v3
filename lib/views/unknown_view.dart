import 'package:flutter/material.dart';

class UnknownView extends StatelessWidget {
  String msg;
  UnknownView(this.msg);

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    print('in unknown: ${Uri.base.toString()}');
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
                style: TextStyle(color: Colors.black),
                children: [
                  const TextSpan(
                    text: '404. ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: msg),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
                'The requested URL ${Uri.base.path.toString()} was not founded this server.'),
          ],
        ),
      ),
    );
  }
}
