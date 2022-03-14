import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/helpers/aes_helper.dart';

class ButtonView extends StatefulWidget {
  const ButtonView({Key? key}) : super(key: key);

  @override
  State<ButtonView> createState() => _ButtonViewState();
}

class _ButtonViewState extends State<ButtonView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  String? codeStr = Get.parameters['code'];
  late int ts;
  late String payload = '';
  late bool use_timeout = false;
  late bool correct_payload = false;

  @override
  void initState() {
    // timeout redirect 설정
    if (use_timeout) {
      animationController = AnimationController(
          duration: const Duration(seconds: 10), vsync: this)
        ..forward()
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            Navigator.pushReplacementNamed(context, '/');
          }
        });
    }

    // parameter decoding
    if (codeStr == null || codeStr == 'develop') {
      // get current timestamp
      ts = DateTime.now().millisecondsSinceEpoch;
      codeStr = AesHelper.enc('${ts.toString()} 00:00:00:00:00:12');
    }

    try {
      payload = AesHelper.extractPayload(codeStr!);
      correct_payload = true;
    } catch (e) {
      print('decryption error $e');
      // initState에서 routing 하기
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //    overlays: [SystemUiOverlay.top]);
    List data = TestData['buttons'];
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    final double mainSpacing = w * .10;

    return Material(
      child: Container(
        // background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            repeat: ImageRepeat.repeat,
            image: NetworkImage(
                'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/background/full/blue.jpeg'),
            //image: NetworkImage(
            //    'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/background/tile/square.jpeg'),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          //backgroundColor: Colors.white,
          body: CupertinoPageScaffold(
            backgroundColor: Colors.transparent,
            child: SizedBox.expand(
              child: SafeArea(
                bottom: false,
                child: Container(
                    child: correct_payload
                        ? GridView.builder(
                            padding: EdgeInsets.all(mainSpacing),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: mainSpacing * .2,
                              crossAxisSpacing: mainSpacing,
                              childAspectRatio: .7,
                            ),
                            itemCount: data.length,
                            itemBuilder: (context, index) => LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                print('tile width: ${constraints.maxWidth}');
                                return Column(
                                  children: [
                                    InkWell(
                                      child: Container(
                                        height: constraints.maxWidth - 2,
                                        width: constraints.maxWidth,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            style: BorderStyle.solid,
                                            width: 0.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: Image.network(
                                            data[index]['image'],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        // child: GridTile(
                                        //   child: Center(child: Text(index.toString())),
                                        //   footer: Center(child: Text(data[index]['name'])),
                                        // ),
                                      ),
                                      onTap: () =>
                                          showCupertinoModalBottomSheet(
                                        expand: false,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => ModalFit(),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        (data[index]['name'] as String)
                                            .replaceAll('<BR>', '\n'),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          //color: Color.computeLuminance() < 0.5
                                          //    ? Colors.white
                                          //    : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : null),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void openBottmSheet() {
    Get.bottomSheet(
      Column(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Bottom Sheet',
              style: TextStyle(fontSize: 18),
            ),
          ),
          OutlinedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Close'))
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class ModalFit extends StatelessWidget {
  const ModalFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Edit'),
            leading: Icon(Icons.edit),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Copy'),
            leading: Icon(Icons.content_copy),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Cut'),
            leading: Icon(Icons.content_cut),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Move'),
            leading: Icon(Icons.folder_open),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Delete'),
            leading: Icon(Icons.delete),
            onTap: () => Navigator.of(context).pop(),
          )
        ],
      ),
    ));
  }
}

const Map<String, dynamic> TestData = {
  "store": {
    "store_no": 35,
    "name": "Restaurant Demo",
    "use_hellobutton_yn": "Y",
    "serial": "V100-00-00019",
    "bell_no": 4487,
    "section_no": 1,
    "section_name": null,
    "table_no": 1,
    "theme": "themabg",
    "noti_p_msg": "Request completed.",
    "noti_c_msg": "Request completed.",
    "url_chg_period": 30,
    "app_no": 2,
    "api_key":
        "74929179C95454739E48660951D21D39AF86F4E603ED5861B5345C254263D941",
    "reg_dt": "2019-02-20T16:24:46.000Z"
  },
  "buttons": [
    {
      "no": 23,
      "name": "Towel",
      "image":
          "https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/button/52_towel.png",
      "desc_img": null,
      "division": "M",
      "tx": 0,
      "message": "Towel",
      "group_no": null,
      "url": "",
      "type": "S",
      "title": "",
      "text": null,
      "items":
          "[\"Small 1\",\" Small 2\",\" Medium 1\",\" Medium 2\",\" Large 1\",\" Large 2\"]",
      "flow_rule": 1,
      "prompt_type": null,
      "prompt_length": null,
      "el": null,
      "disposable": null,
      "noti_p_type": "A",
      "noti_c_type": "A",
      "noti_p_msg": "Request completed.",
      "noti_c_msg": "Request completed.",
      "sel_desc": null,
      "and_host": null,
      "and_scheme": null,
      "and_package": null,
      "and_store": null,
      "ios_appname": null,
      "ios_scheme": null
    },
    {
      "no": 27,
      "name": "Laundry",
      "image":
          "https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/button/52_laundry.png",
      "desc_img": null,
      "division": "M",
      "tx": null,
      "message": "Laundry",
      "group_no": null,
      "url": null,
      "type": "T",
      "title": null,
      "text": null,
      "items": null,
      "flow_rule": 1,
      "prompt_type": null,
      "prompt_length": null,
      "el": null,
      "disposable": null,
      "noti_p_type": "A",
      "noti_c_type": "A",
      "noti_p_msg": "Request completed.",
      "noti_c_msg": "Request completed.",
      "sel_desc": null,
      "and_host": null,
      "and_scheme": null,
      "and_package": null,
      "and_store": null,
      "ios_appname": null,
      "ios_scheme": null
    },
    {
      "no": 28,
      "name": "Toiletries",
      "image":
          "https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/button/52_toiletries.png",
      "desc_img": null,
      "division": "M",
      "tx": null,
      "message": "Toiletries",
      "group_no": null,
      "url": null,
      "type": "S",
      "title": "Please select",
      "text": null,
      "items":
          "[\"Shampoo\", \"Conditioner\", \"Soap\", \"Lotion\", \"Toothpaste\", \"Toothbrushes\"]",
      "flow_rule": 1,
      "prompt_type": null,
      "prompt_length": null,
      "el": null,
      "disposable": null,
      "noti_p_type": "A",
      "noti_c_type": "A",
      "noti_p_msg": "Request completed.",
      "noti_c_msg": "Request completed.",
      "sel_desc": null,
      "and_host": null,
      "and_scheme": null,
      "and_package": null,
      "and_store": null,
      "ios_appname": null,
      "ios_scheme": null
    },
    {
      "no": 24,
      "name": "Room<BR>Service",
      "image":
          "https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/button/52_room_service.png",
      "desc_img": null,
      "division": "M",
      "tx": 0,
      "message": "Service",
      "group_no": null,
      "url": "",
      "type": "S",
      "title": "",
      "text": null,
      "items":
          "[\"Chef's Daily Soup\",\" Caesar Salad\",\" Baja Fish Tacos\",\" Marriott Buger\"]",
      "flow_rule": 1,
      "prompt_type": null,
      "prompt_length": null,
      "el": null,
      "disposable": null,
      "noti_p_type": "A",
      "noti_c_type": "A",
      "noti_p_msg": "Request completed.",
      "noti_c_msg": "Request completed.",
      "sel_desc": null,
      "and_host": null,
      "and_scheme": null,
      "and_package": null,
      "and_store": null,
      "ios_appname": null,
      "ios_scheme": null
    },
    {
      "no": 29,
      "name": "Collect<BR>Room Tray",
      "image":
          "https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/button/36_collect.png",
      "desc_img": null,
      "division": "M",
      "tx": null,
      "message": "Collect Room Tray",
      "group_no": null,
      "url": null,
      "type": "T",
      "title": null,
      "text": null,
      "items": null,
      "flow_rule": 1,
      "prompt_type": null,
      "prompt_length": null,
      "el": null,
      "disposable": null,
      "noti_p_type": "A",
      "noti_c_type": "A",
      "noti_p_msg": "Request completed.",
      "noti_c_msg": "Request completed.",
      "sel_desc": null,
      "and_host": null,
      "and_scheme": null,
      "and_package": null,
      "and_store": null,
      "ios_appname": null,
      "ios_scheme": null
    },
    {
      "no": 30,
      "name": "House<BR>Keeping",
      "image":
          "https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/button/36_housekeeping.png",
      "desc_img": null,
      "division": "M",
      "tx": null,
      "message": "House Keeping",
      "group_no": null,
      "url": null,
      "type": "T",
      "title": null,
      "text": null,
      "items": null,
      "flow_rule": 1,
      "prompt_type": null,
      "prompt_length": null,
      "el": null,
      "disposable": null,
      "noti_p_type": "A",
      "noti_c_type": "A",
      "noti_p_msg": "Request completed.",
      "noti_c_msg": "Request completed.",
      "sel_desc": null,
      "and_host": null,
      "and_scheme": null,
      "and_package": null,
      "and_store": null,
      "ios_appname": null,
      "ios_scheme": null
    },
    {
      "no": 25,
      "name": "Marriott<BR>Web Site",
      "image":
          "https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/button/52_marriott.png",
      "desc_img": null,
      "division": "U",
      "tx": 0,
      "message": "null",
      "group_no": null,
      "url": "https://www.marriott.com",
      "type": "",
      "title": "",
      "text": null,
      "items": "",
      "flow_rule": 1,
      "prompt_type": null,
      "prompt_length": null,
      "el": null,
      "disposable": null,
      "noti_p_type": "A",
      "noti_c_type": "A",
      "noti_p_msg": "Request completed.",
      "noti_c_msg": "Request completed.",
      "sel_desc": null,
      "and_host": null,
      "and_scheme": null,
      "and_package": null,
      "and_store": null,
      "ios_appname": null,
      "ios_scheme": null
    },
    {
      "no": 32,
      "name": "VALET",
      "image":
          "https://bo.hellobell.net/images/vbell/31/list_photo_parking.png",
      "desc_img": null,
      "division": "G",
      "tx": null,
      "message": "Vehicle Requested",
      "group_no": 18,
      "url": null,
      "type": "P",
      "title": "Vehicle Requested",
      "text": "Please enter your ticket or car license number.",
      "items": null,
      "flow_rule": 2,
      "prompt_type": "text",
      "prompt_length": 8,
      "el": null,
      "disposable": null,
      "noti_p_type": "A",
      "noti_c_type": "C",
      "noti_p_msg": "Request being processed.",
      "noti_c_msg": "Request completed.",
      "sel_desc": null,
      "and_host": null,
      "and_scheme": null,
      "and_package": null,
      "and_store": null,
      "ios_appname": null,
      "ios_scheme": null
    },
    {
      "no": 26,
      "name": "Uber",
      "image":
          "https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/button/52_uber.png",
      "desc_img": null,
      "division": "A",
      "tx": 0,
      "message": "null",
      "group_no": null,
      "url": "",
      "type": "",
      "title": "",
      "text": null,
      "items": "",
      "flow_rule": 1,
      "prompt_type": null,
      "prompt_length": null,
      "el": null,
      "disposable": null,
      "noti_p_type": "A",
      "noti_c_type": "A",
      "noti_p_msg": "Request completed.",
      "noti_c_msg": "Request completed.",
      "sel_desc": null,
      "and_host": null,
      "and_scheme": null,
      "and_package": null,
      "and_store": null,
      "ios_appname": null,
      "ios_scheme": null
    },
    {
      "no": 31,
      "name": "Feedback",
      "image": "https://bo.hellobell.net/images/vbell/36/list_photo_review.png",
      "desc_img": null,
      "division": "S",
      "tx": null,
      "message": null,
      "group_no": null,
      "url": null,
      "type": null,
      "title": null,
      "text": null,
      "items": null,
      "flow_rule": 1,
      "prompt_type": null,
      "prompt_length": null,
      "el": "#divEval",
      "disposable": "Y",
      "noti_p_type": null,
      "noti_c_type": "A",
      "noti_p_msg": null,
      "noti_c_msg": null,
      "sel_desc": null,
      "and_host": null,
      "and_scheme": null,
      "and_package": null,
      "and_store": null,
      "ios_appname": null,
      "ios_scheme": null
    }
  ]
};
