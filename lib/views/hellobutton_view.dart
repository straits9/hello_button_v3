import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hello_button_v3/helpers/aes_helper.dart';
import 'package:hello_button_v3/models/site.dart';
import 'package:hello_button_v3/services/global_service.dart';
import 'package:hello_button_v3/services/graphql.dart';
import 'package:hello_button_v3/views/unknown_view.dart';
import 'package:hello_button_v3/views/waiting_view.dart';
import 'package:hello_button_v3/widgets/reorderable_stagger_button.dart';

//
// /hb/:code 처리의 기본 페이지
//
// code input을 처리하고, error 분류를 한뒤, GraphQL로 data를 받아온다.
//
class HelloButtonView extends StatefulWidget {
  const HelloButtonView({Key? key}) : super(key: key);

  @override
  State<HelloButtonView> createState() => _HelloButtonViewState();
}

class _HelloButtonViewState extends State<HelloButtonView> {
  final GlobalService global = GlobalService();
  late String? mac;
  final int ts = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();

    mac = _decodeParam(Get.parameters['code']);
    print('mac: $mac');

    // TODO: 이부부을 사용할 것인지 결정을 해야 한다.
    // html에서 이 페이지를 떠나는 경우 처리
    html.window.onBeforeUnload.listen((event) async {
      print('leave current page');
    });
  }

  String? _decodeParam(String? param) {
    // null 이거나, develop으로 들어오는 경우 (테스트 인 경우) 처리
    if (param == null) return null;
    if (param == 'develop') {
      // develop인 경우 store 35의 virtual mac을 assign해서 새로이 진행한다.
      param = AesHelper.enc('${ts.toString()} 00:00:00:00:00:12');
      // initState내에서는 routing이 안된다.
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        Get.offNamed('/hb/$param');
      });
    }

    // decode 진행, 오류시 mac = null로 변환한다.
    try {
      return AesHelper.extractPayload(param).split(' ')[1];
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mac == null) return UnknownView('mac is not found');

    return GraphQLProvider(
      // client: GraphqlConfig.initClient(), // use static functions
      client: global.initGraphQL(),
      child: Query(
        options: QueryOptions(
          document: gql(Queries.mac),
          variables: {'mac': mac},
        ),
        builder: (QueryResult result, {refetch, fetchMore}) {
          if (result.isLoading) return const WaitingView();
          if (result.hasException) {
            return UnknownView(
                GraphqlConfig.handleError(result.exception as Exception),
                code: 500);
          }

          print(result);
          //
          // data의 내부 logic 에러 처리 시작
          //
          Site? site = result.data?['deviceByMac']?['site'] == null
              ? null
              : Site.fromJson(result.data?['deviceByMac']['site']);
          // 해당 mac을 가진 device가 시스템에 등록되어 있지 않은 경우
          if (site == null) return UnknownView('No such device', code: 500);
          // TODO: device가 시스템에 등록은 되어 있는데, hellobutton을 사용하지 않는 경우.

          return ReorderStaggerButtonView(site: site);
        },
      ),
    );
    //return FullBackgroundImage2();
  }
}
