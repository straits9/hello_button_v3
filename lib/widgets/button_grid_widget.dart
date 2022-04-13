import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hello_button_v3/controllers/auth_controller.dart';
import 'package:hello_button_v3/services/graphql.dart';
import 'package:hello_button_v3/widgets/reorder_grid/reorderable_grid.dart';
import 'package:hello_button_v3/widgets/waiting_widget.dart';

const Map<String, String> prefixes = {
  'http://v2.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3',
  'http://files.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net',
  'https://bo.hellobell.net':
      'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3'
};

class ButtonGridView extends StatelessWidget {
  const ButtonGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController _auth = Get.find();

    return GraphQLProvider(
      client: GraphqlConfig.initClient(),
      child: Query(
          options: QueryOptions(
            document: gql(Queries.site),
            variables: const {'siteid': 35},
          ),
          builder: (result, {refetch, fetchMore}) {
            if (result.hasException) return Text(result.exception.toString());
            if (result.isLoading) return const WaitingView();

            if (result.data?['site'] == null) return Text('No such store!!');

            print(result.data);
            String? storeName = result.data?['site']?['name'];
            List buttons = result.data?['site']?['buttons'];
            print('store name: $storeName');

            return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.grey,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: storeName == null ? null : Text(storeName),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () => {},
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      customButton: const Icon(Icons.add),
                      offset: Offset(-150, 0),
                      //alignment: AlignmentDirectional.bottomStart,
                      dropdownWidth: 160,
                      items: [
                        ...MenuItems.firstItems.map((item) =>
                            DropdownMenuItem<MenuItem>(
                                value: item, child: MenuItems.buildItem(item))),
                        const DropdownMenuItem<Divider>(
                            enabled: false, child: Divider()),
                        ...MenuItems.secondItems.map(
                          (item) => DropdownMenuItem<MenuItem>(
                            value: item,
                            child: MenuItems.buildItem(item),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        print(value);
                        if (value == MenuItems.home) {
                          print('home click, logout');
                          _auth.logout();
                        }
                        MenuItems.onChanged(context, value as MenuItem);
                      },
                    ),
                  ),
                ],
              ),
              resizeToAvoidBottomInset: false,
              body: ButtonGridWidget(buttons: buttons),
            );
          }),
    );
  }
}

class ButtonGridWidget extends StatefulWidget {
  final List<dynamic> buttons;
  const ButtonGridWidget({Key? key, required this.buttons}) : super(key: key);

  @override
  State<ButtonGridWidget> createState() => _ButtonGridWidgetState();
}

class _ButtonGridWidgetState extends State<ButtonGridWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildButton(Map<String, dynamic> btn) {
      return Card(
        key: ValueKey(btn['title']),
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          children: [
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                width: constraints.maxWidth,
                height: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  // borderRadius: const BorderRadius.only(
                  //   topLeft: Radius.circular(20),
                  //   topRight: Radius.circular(20),
                  //   bottomLeft: Radius.circular(20),
                  //   bottomRight: Radius.circular(20),
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                // child: Image.asset("assets/images/splash.png"),
                child: Image.network(imageUrlConvert(btn['image'])),
              );
            }),
            SizedBox(height: 10),
            Expanded(
              child: Text(
                btn['title'].replaceAll("<BR>", '\n'),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return ReorderableGridView.count(
      primary: false,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      crossAxisSpacing: 40,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      childAspectRatio: 4 / 5,
      children: widget.buttons.map((btn) => buildButton(btn)).toList(),
      onReorder: (oldIndex, newIndex) {
        print('reorder $oldIndex => $newIndex');
        setState(() {
          final element = widget.buttons.removeAt(oldIndex);
          widget.buttons.insert(newIndex, element);
        });
      },
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

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [home, share, settings];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Home', icon: Icons.home);
  static const share = MenuItem(text: 'Share', icon: Icons.share);
  static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
        //Do something
        break;
      case MenuItems.settings:
        //Do something
        break;
      case MenuItems.share:
        //Do something
        break;
      case MenuItems.logout:
        //Do something
        break;
    }
  }
}
