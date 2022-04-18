import 'package:flutter/material.dart';
import 'package:hello_button_v3/models/site.dart';
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
      _tiles.add(HelloButtonTile(Key(widget.site.buttons![i].id), Colors.white,
          Icons.widgets, widget.site.buttons![i].image));
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
            )),
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
          backgroundColor: Colors.transparent,
          // backgroundColor: const Color.fromRGBO(0, 0, 0, 0.1),
          // flexibleSpace: widget.site.logo == null
          //     ? null
          //     : Container(
          //       padding: EdgeInsets.only(right: 40),
          //       child: Center(
          //         child: Image(
          //             image: NetworkImage(widget.site.logo!),
          //             fit: BoxFit.contain,
          //           ),
          //       ),
          //     ),
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
        body: SafeArea(
          child: ReorderableItemsView(
            padding: EdgeInsets.all(0.1 * w),
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
            mainAxisSpacing: 0.1 * w,
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
    this.backgroundColor,
    this.iconData,
    this.image,
  ) : super(key: key);

  final Color backgroundColor;
  final String? image;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: () {
          print('tab $key');
        },
        child: Stack(children: [
          if (image != null)
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:
                    Image.network(imageUrlConvert(image!), fit: BoxFit.cover),
              ),
            ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                iconData,
                color: Colors.white,
              ),
            ),
          ),
        ]),
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
