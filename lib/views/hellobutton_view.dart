import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:hello_button_v3/helpers/aes_helper.dart';
import 'package:hello_button_v3/models/site.dart';
import 'package:hello_button_v3/services/global_service.dart';
import 'package:hello_button_v3/services/graphql.dart';
import 'package:hello_button_v3/views/timeout_view.dart';
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
  final int ts = (DateTime.now().millisecondsSinceEpoch / 1000).round();
  late String? mac;
  late int? diff;
  late int qrTime;
  bool reRoute = false;

  @override
  void initState() {
    super.initState();

    mac = _decodeParam(Get.parameters['code']);
    print('mac: $mac');

    // TODO: 이부분을 사용할 것인지 결정을 해야 한다.
    // html에서 이 페이지를 떠나는 경우 처리
    html.window.onBeforeUnload.listen((event) async {
      print('leave current page');
    });

    // web index.html에서 설정해놓은 status bar 관련 function을 호출한다.
    if (kIsWeb) {
      js.context.callMethod('setMetaThemeColor', ['transparent']);
      // js.context.callMethod('lockScreen');
    }
  }

  // :code parameter를 분석하는 부분
  //
  // code = 'develop'인 경우 다시 encode하여서 자체적으로 redirect한다
  // code -> qrcode timestamp, mac address로 분리후 현재의 timestamp와 차이를 관리한다.
  //  밑에서 store 정보를 가져온 이후에 store마다 설정된 차이를 넘어가는 경우 redirect를 진행하기 위해서 이다.
  //
  String? _decodeParam(String? param) {
    // null 이거나, develop으로 들어오는 경우 (테스트 인 경우) 처리
    if (param == null) return null;
    if (param == 'develop') {
      // develop인 경우 store 35의 virtual mac을 assign해서 새로이 진행한다.
      param = AesHelper.enc('${ts.toString()} 00:00:00:00:00:12');
      // initState내에서는 routing이 안되기 때문에 redirect를 scheduling해야 한다.
      reRoute = true;
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        Get.offNamed('/hb/$param');
      });
      return null;
    }

    // decode 진행, 오류시 mac = null로 변환한다.
    try {
      List decoded = AesHelper.extractPayload(param).trim().split(' ');
      diff = ts - (qrTime = int.parse(decoded[0]));
      // decrypt 뒷부분에 네개의 0가 붙는데 이를 제거하기 위해서 substring을 사용한다.
      return (decoded[1] as String).substring(0, 17);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // initState에서 Get.offName으로 reroute를 schedule한 경우
    // 현재 widget을 삭제후 진행하므로 dummy widget이 존재해야 한다.
    if (reRoute) return Container();
    // mac이 없는 경우는 error 페이지를 표시한다
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

          //
          // data의 내부 logic
          //
          Site? site = result.data?['deviceByMac']?['site'] == null
              ? null
              : Site.fromJson(result.data?['deviceByMac']['site']);
          // 해당 mac을 가진 device가 시스템에 등록되어 있지 않은 경우
          if (site == null) return UnknownView('No such device', code: 500);

          // TODO: device가 시스템에 등록은 되어 있는데, hellobutton을 사용하지 않는 경우 처리. 현재는 site=null로 넘어감.

          // HelloButton 페이지 자체의 timeout 처리에 대한 처리
          int secTimeout = site.validWithin! * 60;
          //int secTimeout = site.validWithin!; // for short time test
          print('time difference(sec): $diff');
          if (site.validWithin! == 0) {
            //
            // validWithin = 0 값의 의미는 page timeout을 진행하지 않는다는 의미이다.
            //
            return ReorderStaggerButtonView(site: site);
          } else if (diff! > secTimeout) {
            //
            // 이미 사용가능한 시간을 지난 경우
            //
            return const TimeoutView();
          } else {
            //
            // 사용 가능한 시간을 지나지 않은 경우 - timeout event를 만들어야 한다.
            //
            int timeout = qrTime + secTimeout - ts;
            print('estimate timeout within $timeout (secs)');
            return FutureBuilder(
              future: Future.delayed(Duration(seconds: timeout), () {
                // 일정 시간 이후에 timeoutview로 이동한다
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const TimeoutView();
                    },
                  ),
                  (route) => false,
                );
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return ReorderStaggerButtonView(site: site);
                }
                return const TimeoutView();
              },
            );
          }
        },
      ),
    );
  }
}
