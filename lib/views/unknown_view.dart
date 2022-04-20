import 'package:flutter/material.dart';

// 사용자에게 보여주는 에러페이지
// google의 404 페이지를 참고로 진행하였다.
class UnknownView extends StatelessWidget {
  String? msg;
  int code;
  UnknownView(this.msg, {this.code = 404});

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    // final double h = MediaQuery.of(context).size.height;

    String desc = code >= 500
        ? 'There is an error while processing. please contact system administrator with above error code.'
        : 'The requested URL ${Uri.base.path.toString()} was not founded this server.';
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(0.1 * w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // hello factory logo
            Image.asset('assets/images/bottom2.png'),
            const SizedBox(height: 40),

            // error code, title (error code를 bold처리)
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
            
            // 아래 설명
            Text(desc),
          ],
        ),
      ),
    );
  }
}
