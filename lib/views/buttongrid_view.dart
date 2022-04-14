import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:hello_button_v3/controllers/auth_controller.dart';
import 'package:hello_button_v3/services/graphql.dart';
import 'package:hello_button_v3/widgets/button_grid_widget.dart';
import 'package:hello_button_v3/views/waiting_view.dart';

class ButtonGridView extends StatefulWidget {
  final bool useSliverHeader;
  final Role role;
  const ButtonGridView({
    Key? key,
    this.useSliverHeader = false,
    this.role = Role.none,
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
    html.window.onBeforeUnload.listen((event) async {
      _auth.logout();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          Widget? title = storeName == null ? null : Text(storeName);

          return Scaffold(
            // statusbar background 변경에 대한 테스트
            // extendBodyBehindAppBar: true,
            // resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: widget.useSliverHeader ? null : buttonGridAppBar(title),
            body: buttonGridBody(
              widget.useSliverHeader,
              child: ButtonGridWidget(buttons: buttons, role: Role.admin),
              title: title,
            ),
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
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => {},
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (String newMenu) {
            print('select menu $newMenu');
          },
          itemBuilder: (BuildContext context) => ['one', 'two', 'three']
              .map((String menu) =>
                  PopupMenuItem<String>(value: menu, child: Text(menu)))
              .toList(),
        ),
      ],
    );
  }

  Widget buttonGridBody(bool useSliver,
      {required Widget child, Widget? title}) {
    if (!useSliver) return child;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          snap: false,
          floating: false,
          expandedHeight: 160.0,
          flexibleSpace: FlexibleSpaceBar(
            title: title,
            background:
                Image.asset('assets/images/splash.png', fit: BoxFit.fill),
          ),
        ),
        SliverFillRemaining(
          child: child,
        )
      ],
    );
  }
}
