import 'package:flutter/material.dart';
import 'package:hello_button_v3/controllers/auth_controller.dart';

import 'package:hello_button_v3/widgets/reorder_grid/reorderable_grid.dart';

const Map<String, String> prefixes = {
  'http://v2.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3',
  'http://files.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net',
  'https://bo.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3'
};

///
/// HelloButton의 button grid를 만들어내는 widget
/// input: button data structure (array)
///
/// TODO: reorderable을 enable, disable할 수 있게 하는 방법을 찾을것
///
class ButtonGridWidget extends StatefulWidget {
  final List<dynamic> buttons;
  final Role role;
  // final int manage;
  const ButtonGridWidget({Key? key, required this.buttons, required this.role})
      : super(key: key);

  @override
  State<ButtonGridWidget> createState() => _ButtonGridWidgetState();
}

class _ButtonGridWidgetState extends State<ButtonGridWidget> {
  late final bool manage;
  @override
  void initState() {
    super.initState();
    manage = widget.role.index >= Role.manager.index;
    print('Role: ${widget.role}, ${widget.role.index} manage? $manage');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double hSpacing = size.width / 10;
    double vSpacing = size.width / 30;

    return manage
        ? ReorderableGridView.count(
            primary: false,
            padding:
                EdgeInsets.symmetric(horizontal: hSpacing, vertical: vSpacing),
            crossAxisSpacing: hSpacing,
            mainAxisSpacing: vSpacing,
            childAspectRatio: 3 / 4,
            children: widget.buttons.map((btn) => buildButton(btn)).toList(),
            crossAxisCount: 2,
            onReorder: (oldIndex, newIndex) {
              print('reorder $oldIndex => $newIndex');
              setState(() {
                final element = widget.buttons.removeAt(oldIndex);
                widget.buttons.insert(newIndex, element);
              });
            },
          )
        : GridView.count(
            crossAxisCount: 2,
            primary: false,
            padding:
                EdgeInsets.symmetric(horizontal: hSpacing, vertical: vSpacing),
            crossAxisSpacing: hSpacing,
            mainAxisSpacing: vSpacing,
            childAspectRatio: 3 / 4,
            children: widget.buttons.map((btn) => buildButton(btn)).toList(),
          );
  }

  //
  //  각각의 button을 생성
  //  Card 내부에 정사각형 image와 밑에 title을 가지는 구조이다.
  //
  Widget buildButton(Map<String, dynamic> btn) {
    return Card(
      key: ValueKey(btn['title']),
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
                  child: Image.network(imageUrlConvert(btn['image']),
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
                      btn['title'].replaceAll("<BR>", '\n'),
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

  // 이전 version과 compatibility를 유지하기 위해서 S3 bucket <files.hellobell.net>에
  // vue /images directory를 옮겨놓고 이를 secure한 uri로 변경한다.
  String imageUrlConvert(String uri) {
    var matches = prefixes.keys
        .firstWhere((key) => uri.startsWith(key), orElse: () => '');

    if (matches != '') {
      var modified = uri.replaceFirst(matches, prefixes[matches]!);
      //print('conv url: $uri => $modified');
      return modified;
    }
    return uri;
  }
}
