import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:hello_button_v3/controllers/auth_controller.dart';
import 'package:hello_button_v3/models/user.dart';
import 'package:hello_button_v3/services/graphql.dart';
import 'package:hello_button_v3/widgets/button_grid_widget.dart';
import 'package:hello_button_v3/views/waiting_view.dart';

class ButtonGridView extends StatefulWidget {
  final bool useSliverHeader;
  final User? user;
  const ButtonGridView({
    Key? key,
    this.user,
    this.useSliverHeader = false,
  }) : super(key: key);

  @override
  State<ButtonGridView> createState() => _ButtonGridViewState();
}

class _ButtonGridViewState extends State<ButtonGridView> {
  final AuthController _auth = Get.find();

  @override
  void initState() {
    super.initState();

    // browser에서 이 페이지를 벗어나는 경우 logout을 한다.
    // html.window.onBeforeUnload.listen((event) async {
    //   _auth.logout();
    // });
  }

  @override
  Widget build(BuildContext context) {
    print('user: ${widget.user}');
    print(Theme.of(context).platform);
    return GraphQLProvider(
      client: GraphqlConfig.initClient(),
      child: Query(
        options: QueryOptions(
          document: gql(Queries.site),
          variables: {'siteid': widget.user?.siteId},
        ),
        builder: (result, {refetch, fetchMore}) {
          if (result.hasException) return Text(result.exception.toString());
          if (result.isLoading) return const WaitingView();

          print(result);
          if (result.data?['site'] == null) return Text('No such store!!');

          print(result.data);
          String? storeName = result.data?['site']?['name'];
          List buttons = result.data?['site']?['buttons'];
          print('store name: $storeName');
          Widget? title = storeName == null ? null : Text(storeName);

          return Scaffold(
            // statusbar background 변경에 대한 테스트
            // extendBodyBehindAppBar: true,
            // resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: widget.useSliverHeader ? null : buttonGridAppBar(title),
            body: widget.useSliverHeader
                ? sliverGrid(
                    title: title,
                    child: ButtonGridWidget(buttons: buttons, role: Role.admin))
                : ButtonGridWidget(buttons: buttons, role: Role.admin),
          );
        },
      ),
    );
  }

  AppBar buttonGridAppBar(Widget? title) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      title: title,
      centerTitle: true,
      actions: [
        // IconButton(
        //   icon: const Icon(Icons.more_vert),
        //   onPressed: () => {},
        // ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (String menuId) {
            print('select menu $menuId');
            switch (menuId) {
              case 'logout':
                _auth.logout();
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            {'id': 'logout', 'title': 'logout'},
            'two',
            'three'
          ].map((dynamic menu) {
            if (menu.runtimeType == String) {
              return PopupMenuItem<String>(value: menu, child: Text(menu));
            } else {
              return PopupMenuItem<String>(
                  value: menu['id'], child: Text(menu['title']));
            }
          }).toList(),
        ),
      ],
    );
  }

  Widget sliverGrid({required Widget child, Widget? title}) {
    // return NestedScrollView(
    //   floatHeaderSlivers: true,
    //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //     return <Widget>[
    //       SliverAppBar(
    //         pinned: true,
    //         snap: true,
    //         floating: true,
    //         expandedHeight: 160.0,
    //         flexibleSpace: FlexibleSpaceBar(
    //           title: title,
    //           background:
    //               Image.asset('assets/images/splash.png', fit: BoxFit.fill),
    //         ),
    //         forceElevated: innerBoxIsScrolled,
    //       ),
    //        SliverGrid(
    //           gridDelegate:
    //               SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    //           delegate: SliverChildListDelegate(
    //             [
    //               Container(color: Colors.red, height: 150.0),
    //               Container(color: Colors.purple, height: 150.0),
    //               Container(color: Colors.green, height: 150.0),
    //               Container(color: Colors.cyan, height: 150.0),
    //               Container(color: Colors.indigo, height: 150.0),
    //               Container(color: Colors.black, height: 150.0),
    //             ],
    //           )),
    //     ];
    //   },
    //   body: SliverGrid(
    //       gridDelegate:
    //           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    //       delegate: SliverChildListDelegate(
    //         [
    //           Container(color: Colors.red, height: 150.0),
    //           Container(color: Colors.purple, height: 150.0),
    //           Container(color: Colors.green, height: 150.0),
    //           Container(color: Colors.cyan, height: 150.0),
    //           Container(color: Colors.indigo, height: 150.0),
    //           Container(color: Colors.black, height: 150.0),
    //         ],
    //       )),
    // );
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          pinned: true,
          snap: true,
          floating: true,
          expandedHeight: 160.0,
          flexibleSpace: FlexibleSpaceBar(
            title: title,
            background:
                Image.asset('assets/images/splash.png', fit: BoxFit.fill),
          ),
        ),
        child,
        // SliverGrid.count(
        //     gridDelegate:
        //         SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        //     delegate: SliverChildListDelegate(
        //       [
        //         Container(color: Colors.red, height: 150.0),
        //         Container(color: Colors.purple, height: 150.0),
        //         Container(color: Colors.green, height: 150.0),
        //         Container(color: Colors.cyan, height: 150.0),
        //         Container(color: Colors.indigo, height: 150.0),
        //         Container(color: Colors.black, height: 150.0),
        //         Container(color: Colors.red, height: 150.0),
        //         Container(color: Colors.purple, height: 150.0),
        //         Container(color: Colors.green, height: 150.0),
        //         Container(color: Colors.cyan, height: 150.0),
        //         Container(color: Colors.indigo, height: 150.0),
        //         Container(color: Colors.black, height: 150.0),
        //         Container(color: Colors.red, height: 150.0),
        //         Container(color: Colors.purple, height: 150.0),
        //         Container(color: Colors.green, height: 150.0),
        //         Container(color: Colors.cyan, height: 150.0),
        //         Container(color: Colors.indigo, height: 150.0),
        //         Container(color: Colors.black, height: 150.0),
        //       ],
        //     )),
        // SliverFillRemaining(
        //   child: child
        // )
      ],
    );
  }
}
