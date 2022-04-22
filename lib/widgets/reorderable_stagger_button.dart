import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_button_v3/widgets/action_user_if.dart';
import 'package:hello_button_v3/widgets/button_tile_overlap.dart';
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
      case 'Call':
        bool cont = await showConfirmDialog(
            context, 'You choose the \'${button.title}\' request.');
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
              bool cont = await showConfirmDialog(context,
                  'You choose the \'${button.action.message!} (${val.trim()})\' request.');
              print(cont);
            }
            break;
          case 'JustText':
            bool cont = await showConfirmDialog(context,
                'You choose the \'${button.action.message!}\' request.');
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
