import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_button_v3/widgets/action_user_if.dart';
import 'package:reorderableitemsview/reorderableitemsview.dart';

import 'package:hello_button_v3/models/button.dart';
import 'package:hello_button_v3/models/site.dart';

//
// Site 정보를 가지고 hello button 페이지를 생성
// param: Site
//
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

    // staggered grid를 만들기 위한 grid structure를 생성
    for (var i = 0; i < widget.site.buttons!.length; i++) {
      // 기본적인 tile
      _tiles.add(ButtonTileOverlap(
        Key(widget.site.buttons![i].id),
        widget.site.buttons![i],
        _buttonClickHandler, // onTap handler
      ));
      // stagger grid의 size를 관리하는 tile (reorder에 사용된다)
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
      // background가 설정이 되어 있는 경우 처리
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
          extendBodyBehindAppBar: true, // appbar 부분까지 통합 control
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Center(
              child: Text(
                widget.site.name,
                textScaleFactor: 1.0,
                maxLines: 2,
                style: const TextStyle(
                  // background에 의한 text color가 안보일때를 대비해서 shadow로 변별하게 처리
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
            elevation: 0, // appbar 부분까지 통합하는 내용
            //backgroundColor: Colors.transparent,
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
            // Blur filter를 appbar에 적용
            flexibleSpace: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            toolbarHeight: h * 0.15, // appbar size: 15% of height

            // appbar 오른쪽 button 정의
            actions: [
              IconButton(
                onPressed: () => {
                  setState(() => {bGrid = !bGrid})
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),

          // TODO: 상태에 따라서 reorderable이냐 기존 grid냐를 분기해야 함
          body: ReorderableItemsView(
            crossAxisCount: 4, // stagger grid를 위해서
            padding: EdgeInsets.symmetric(
              horizontal: 0.1 * w,
              vertical: 0.07 * w,
            ),
            children: _tiles,
            staggeredTiles: _listStaggeredTileExtended,
            isGrid: bGrid,
            longPressToDrag: true,
            mainAxisSpacing: 0.07 * w,
            crossAxisSpacing: 0.1 * w,
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                _tiles.insert(newIndex, _tiles.removeAt(oldIndex));
              });
            },
          ),
        ),
      ),
    );
  }

  void _buttonClickHandler(Button button) async {
    print(button.action);
    switch (button.action.typename) {
      case 'Rating':
        showRatingDialog(context, widget.site.logo);
        break;
      case 'Link':
        launchURL(button.action.url!);
        break;
      case 'CallMessage':
      case 'Group':
        switch (button.action.userinput?.typename) {
          case 'UserInput':
            String? val = await showTextDialog(context,
                button.action.userinput?.title, button.action.userinput?.text);
            print('after text dialog: $val');
            break;
          case 'Selection':
            String? val = await showSelection(context, button.action);
            print('after selection $val');
            if (val != null) {
              bool cont = await showConfirmDialog(context, 'You choose the \'${button.action.message!} (${val.trim()})\' request.');
              print(cont);
            }
            break;
          case 'JustText':
            bool cont = await showConfirmDialog(context, 'You choose the \'${button.action.message!}\' request.');
            print(cont);
            break;
          default:
            break;
        }
        break;
      default:
        ;
    }
  }
}

// image를 background로 처리하고 그 위 하단에 title을 표시하는 button
class ButtonTileOverlap extends StatelessWidget {
  final Button button;
  final Function(Button) ontap;
  const ButtonTileOverlap(
    Key key,
    this.button,
    this.ontap,
  ) : super(key: key);

  final double round = 20.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(round)),
      child: InkWell(
        onTap: () async {
          ontap.call(button);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(round),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrlConvert(button.image!))),
          ),

          // image 위에 text를 배치하기 위해서 text에 대한 alignment와
          // background image와의 분별력을 위해서 적당한 opacity의 block과 blur filter를
          // 배치하여 그 위에 text를 drawing한다
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(round),
                bottomRight: Radius.circular(round)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                width: double.infinity,
                color: const Color.fromRGBO(0, 0, 0, 0.2),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  // 기존 data에 line feed를 <BR>로 표기하였기 때문에 replace 필요
                  child: Text(
                    button.title.replaceAll("<BR>", '\n'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.3),
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

// button을 조금더 길게 만들고 상부에 image를 정사각형으로 배치하고, image를 벗어난 하단에 title을 표시하는 button
class ButtonTileOutsideTitle extends StatelessWidget {
  final Button button;
  final Function(Button) ontap;
  const ButtonTileOutsideTitle({
    Key? key,
    required this.button,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(button.title),
      elevation: 0,
      // color: Colors.white,
      child: IntrinsicHeight(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: constraints.maxWidth,
                // color: Colors.yellow,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(imageUrlConvert(button.image!),
                      fit: BoxFit.cover),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      button.title.replaceAll("<BR>", '\n'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// 이전 version과 compatibility를 유지하기 위해서 S3 bucket <files.hellobell.net>에
// vue /images directory를 옮겨놓고 이를 secure한 uri로 변경한다.
const Map<String, String> prefixes = {
  'http://v2.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3',
  'http://files.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net',
  'https://bo.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3'
};

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
