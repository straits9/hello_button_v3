import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:hello_button_v3/models/button.dart';
import 'package:hello_button_v3/widgets/rating_dialog.dart';
import 'package:hello_button_v3/widgets/text_dialog.dart';

//
// 사용자의 input을 받거나 상태를 보여주는 interaction들
//

// 사용자가 button을 누를때 마지막으로 confirm하는 dialog
Future<bool> showConfirmDialog(BuildContext context, String message) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        // title: const Text('Confirm'),
        title: const Text('확인'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
              // const Text('Do you want to continue?'),
              const Text('계속 진행할까요?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            // child: const Text('Cancel'),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            // child: const Text('Confirm'),
            child: const Text('확인'),
          ),
        ],
      );
    },
  );
}

void launchURL(String url) async {
  if (!await launch(url)) {
    print('error launch');
  }
}

Future<String?> showSelection(
    BuildContext context, ButtonAction action) async {
  print('items: ${action.userinput?.items}');
  return await showCupertinoModalBottomSheet(
    context: context,
    expand: false,
    builder: (BuildContext context) {
      return Material(
        child: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              action.userinput?.title == null || action.userinput?.title == ''
                  ? const SizedBox(height: 5)
                  : Container(
                      height: 50,
                      child: Center(
                        child: Text(
                          action.userinput!.title!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
              ...action.userinput!.items!
                  .map((String item) => ListTile(
                        title: Text(item.trim()),
                        onTap: () {
                          print('select: $item');
                          Navigator.of(context).pop(item);
                          //Navigator.pop(context, item);
                        },
                      ))
                  .toList(),
            ],
          ),
        ),
      );
    },
  );
}

Future<String?> showTextDialog(BuildContext context,
    [String? title, String? message, String? logo]) async {
  print('title: $title, msg: $message, logo: $logo');
  final _dialog = TextDialog(
    title: Text(
      title ?? '',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    message: message == null
        ? null
        : Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
    // submitButtonText: 'Submit',
    submitButtonText: '확인',
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) {
      print('text: ${response.text}');
    },
  );

  return await showDialog(
    context: context,
    barrierDismissible: true, // set to false if you want to force a rating
    builder: (context) => _dialog,
  );
}

// show the rating dialog
void showRatingDialog(BuildContext context, String? logo) async {
  final _dialog = RatingDialog(
    initialRating: 0.0,
    // your app's name?
    title: const Text(
      // 'Service Satisfication',
      '고객 만족도 조사',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    // encourage your user to leave a high rating?
    message: const Text(
      // 'Please indicate your level of satisfaction to provide better service.',
      '더 나은 서비스를 제공하기 위해 귀하의 만족도를 표시해 주세요.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15),
    ),
    // your app's logo?
    // image: Image.asset('assets/images/bottom2.png'),
    image: logo != null ? Image.network(logo) : null,
    // submitButtonText: 'Submit',
    submitButtonText: '등록',
    // commentHint: 'Any improvements you would like to see.',
    commentHint: '개선사항을 적어주세요.',
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) {
      print('rating: ${response.rating}, comment: ${response.comment}');

      // TODO: add your own logic
      if (response.rating < 3.0) {
        // send their comments to your email or anywhere you wish
        // ask the user to contact you instead of leaving a bad review
      } else {
        //_rateAndReviewApp();
      }
    },
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: true, // set to false if you want to force a rating
    builder: (context) => _dialog,
  );
}
