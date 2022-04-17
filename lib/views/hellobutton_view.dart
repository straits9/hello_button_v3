import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hello_button_v3/helpers/aes_helper.dart';
import 'package:hello_button_v3/services/graphql.dart';
import 'package:hello_button_v3/views/unknown_view.dart';
import 'package:hello_button_v3/views/waiting_view.dart';
import 'package:hello_button_v3/widgets/reorderable_staffer_button.dart';

class HelloButtonView extends StatefulWidget {
  const HelloButtonView({Key? key}) : super(key: key);

  @override
  State<HelloButtonView> createState() => _HelloButtonViewState();
}

class _HelloButtonViewState extends State<HelloButtonView> {
  late String? codeStr;
  late String? mac;
  final int ts = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();

    codeStr = Get.parameters['code'];
    mac = _decodeParam(codeStr);
    print('mac: $mac');

    // html에서 이 페이지를 떠나는 경우 처리
    html.window.onBeforeUnload.listen((event) async {
      print('leave current page');
    });
  }

  String? _decodeParam(String? param) {
    if (param == null) return null;
    if (param == 'develop') {
      param = AesHelper.enc('${ts.toString()} 00:00:00:00:00:12');
      // initState내에서는 routing이 안된다.
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        Get.offNamed('/hb/$param');
      });
    }

    // decode 진행
    try {
      return AesHelper.extractPayload(param).split(' ')[1];
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mac == null) return UnknownView('mac is not found');

    return GraphQLProvider(
      client: GraphqlConfig.initClient(),
      child: Query(
        options: QueryOptions(
          document: gql(Queries.mac),
          variables: {'mac': mac},
        ),
        builder: (result, {refetch, fetchMore}) {
          if (result.hasException) return Text(result.exception.toString());
          if (result.isLoading) return const WaitingView();

          print(result);
          return ReorderStaggerButtonView(buttons: []);
        },
      ),
    );
    //return FullBackgroundImage2();
  }
}

class FullBackgroundImage1 extends StatelessWidget {
  const FullBackgroundImage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          'How to Flutter',
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        //decoration: BoxDecoration(
        //  image: DecorationImage(
        //    image: AssetImage('assets/images/back1.jpg'),
        //    fit: BoxFit.fill,
        //  ),
        //),
        child: SafeArea(child: Text('Body')),
      ),
    );
  }
}

class FullBackgroundImage2 extends StatelessWidget {
  const FullBackgroundImage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //decoration: null,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            'assets/images/back1.jpg',
          ),
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 100,
          title: Text(
            'How to Flutter',
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Text('Body'),
        ),
      ),
    );
  }
}
