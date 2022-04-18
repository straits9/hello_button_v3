import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hello_button_v3/models/button.dart';
import 'package:hello_button_v3/models/site.dart';
import 'package:hello_button_v3/widgets/rating_dialog.dart';
import 'package:reorderableitemsview/reorderableitemsview.dart';

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
          Key(widget.site.buttons![i].id), widget.site.buttons![i]));
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
}

class HelloButtonTile extends StatelessWidget {
  const HelloButtonTile(
    Key key,
    this.button,
  ) : super(key: key);

  final Button button;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: () {
          print('tab ${button.id} ${button.actionId} ${button.inputTypeId}');
          print(button.action);
          _showRatingDialog(context);
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

  // show the rating dialog
  void _showRatingDialog(context) {
    // actual store listing review & rating
    //void _rateAndReviewApp() async {
    //  // refer to: https://pub.dev/packages/in_app_review
    //  final _inAppReview = InAppReview.instance;

    //  if (await _inAppReview.isAvailable()) {
    //    print('request actual review from store');
    //    _inAppReview.requestReview();
    //  } else {
    //    print('open actual store listing');
    //    // TODO: use your own store ids
    //    _inAppReview.openStoreListing(
    //      appStoreId: '<your app store id>',
    //      microsoftStoreId: '<your microsoft store id>',
    //    );
    //  }
    //}

    final _dialog = RatingDialog(
      initialRating: 1.0,
      // your app's name?
      title: Text(
        'Rating Dialog',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: Text(
        'Tap a star to set your rating. Add more description here if you want.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image: const FlutterLogo(size: 50),
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
