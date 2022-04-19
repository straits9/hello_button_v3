import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reorderableitemsview/reorderableitemsview.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:hello_button_v3/models/button.dart';
import 'package:hello_button_v3/models/site.dart';
import 'package:hello_button_v3/widgets/rating_dialog.dart';
import 'package:hello_button_v3/widgets/text_dialog.dart';

class ReorderStaggerButtonView extends StatefulWidget {
  final Site site;
  const ReorderStaggerButtonView({
    Key? key,
    required this.site,
  }) : super(key: key);

  @override
  State<ReorderStaggerButtonView> createState() =>
      _ReorderStaggerButtonViewState();
}

class _ReorderStaggerButtonViewState extends State<ReorderStaggerButtonView> {
  final List<StaggeredTileExtended> _listStaggeredTileExtended = [];
  final List<Widget> _tiles = <Widget>[];

  bool bGrid = true;
  @override
  void initState() {
    super.initState();
    bGrid = true;
    for (var i = 0; i < widget.site.buttons!.length; i++) {
      _tiles.add(HelloButtonTile(
        Key(widget.site.buttons![i].id),
        widget.site.buttons![i],
        _actionProcessing,
      ));
      _listStaggeredTileExtended.add(StaggeredTileExtended.count(2, 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: widget.site.background == null
          ? null
          : BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.site.background!),
                fit: BoxFit.cover,
              ),
            ),
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Center(
              child: Text(
                widget.site.name,
                textScaleFactor: 1.0,
                maxLines: 2,
                style: const TextStyle(
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 15.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
            elevation: 0,
            //backgroundColor: Colors.transparent,
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
            flexibleSpace: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            toolbarHeight: h * 0.15,
            actions: [
              IconButton(
                onPressed: () => {
                  setState(() => {bGrid = !bGrid})
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          body: ReorderableItemsView(
            padding:
                EdgeInsets.symmetric(horizontal: 0.1 * w, vertical: 0.07 * w),
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                _tiles.insert(newIndex, _tiles.removeAt(oldIndex));
              });
            },
            children: _tiles,
            crossAxisCount: 4,
            isGrid: bGrid,
            staggeredTiles: _listStaggeredTileExtended,
            longPressToDrag: true,
            mainAxisSpacing: 0.07 * w,
            crossAxisSpacing: 0.1 * w,
          ),
        ),
      ),
    );
  }

  void _actionProcessing(Button button) async {
    print(button.action);
    switch (button.action.typename) {
      case 'Rating':
        _showRatingDialog(context, widget.site.logo);
        break;
      case 'Link':
        _launchURL(button.action.url!);
        break;
      case 'CallMessage':
      case 'Group':
        switch (button.action.userinput?.typename) {
          case 'UserInput':
            String? val = await _showTextDialog(context,
                button.action.userinput?.title, button.action.userinput?.text);
            print('after text dialog: $val');
            break;
          case 'Selection':
            String? val = await _showSelection(context, button.action);
            print('after selection $val');
            if (val != null) {
              await _showAlertDialog();
            }
            break;
          case 'JustText':
          default:
            break;
        }
        break;
      default:
        ;
    }
  }

  Future<void> _showAlertDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Text'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('this is a demo'),
                Text('hfjdaskf hdjaskf jsalkhfda'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Approve'),
            ),
          ],
        );
      },
    );
  }

  void _launchURL(String url) async {
    if (!await launch(url)) {
      print('error launch');
    }
  }

  Future<String?> _showSelection(
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

  Future<String?> _showTextDialog(BuildContext context,
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
      submitButtonText: 'Submit',
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
  void _showRatingDialog(BuildContext context, String? logo) async {
    final _dialog = RatingDialog(
      initialRating: 3.0,
      // your app's name?
      title: const Text(
        'Rating Dialog',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: const Text(
        'Tap a star to set your rating. Add more description here if you want.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
      // your app's logo?
      // image: Image.asset('assets/images/bottom2.png'),
      image: logo != null ? Image.network(logo) : null,
      submitButtonText: 'Submit',
      commentHint: 'Set your custom comment hint',
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
}

class HelloButtonTile extends StatelessWidget {
  const HelloButtonTile(
    Key key,
    this.button,
    this.callback,
  ) : super(key: key);

  final Button button;
  final Function(Button) callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: () async {
          callback.call(button);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(imageUrlConvert(button.image!)),
            ),
          ),
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                width: double.infinity,
                color: const Color.fromRGBO(0, 0, 0, 0.2),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    button.title.replaceAll("<BR>", '\n'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.3),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const Map<String, String> prefixes = {
  'http://v2.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3',
  'http://files.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net',
  'https://bo.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3'
};

// 이전 version과 compatibility를 유지하기 위해서 S3 bucket <files.hellobell.net>에
// vue /images directory를 옮겨놓고 이를 secure한 uri로 변경한다.
String imageUrlConvert(String uri) {
  var matches =
      prefixes.keys.firstWhere((key) => uri.startsWith(key), orElse: () => '');

  if (matches != '') {
    var modified = uri.replaceFirst(matches, prefixes[matches]!);
    //print('conv url: $uri => $modified');
    return modified;
  }
  return uri;
}
