import 'package:hello_button_v3/models/button.dart';

class Site {
  int? no;
  String? name;
  bool useButton;
  String? locale;
  ButtonBase? button;

  Site({this.no, this.name, this.useButton = false, this.locale, this.button});

  factory Site.fromJson(Map<String, dynamic> json) {
    var siteInfo = json['store'];
    var button = ButtonBase.fromJson(json);
    return Site(
      no: siteInfo['store_no'],
      name: siteInfo['name'],
      useButton: siteInfo['use_hellobutton_yn'] == 'Y',
      locale: siteInfo['locale'] ?? 'ko-KR',
      button: button,
    );
  }

  Map<String, dynamic> toJson() => {
        'store_no': no,
        'name': name,
        'use_hellobutton_yn': useButton ? 'Y' : 'N',
        'locale': locale,
        'button': button,
      };

  @override
  String toString() => toJson().toString();
}

class ButtonBase {
  String? theme; // hello button page theme
  String? background; // hello button page background
  String? msgProcess; // process message
  String? msgComplete; // complete message
  int urlChangePeriod; // url change period (second)

  int? appNo; // registered hellobutton app no
  String? apiKey; // api key for follow operation
  DateTime? registeredAt; // hello button register date
  String? locale;

  ButtonBase({
    this.theme,
    this.background,
    this.msgProcess,
    this.msgComplete,
    this.urlChangePeriod = 0,
    this.appNo,
    this.apiKey,
    this.registeredAt,
    this.locale,
  });

  factory ButtonBase.fromJson(Map<String, dynamic> json) {
    var siteInfo = json['store'];
    // List<Button> buttons = [];
    // if (json.containsKey('buttons')) {
    //   final List<dynamic> btnJson = json['buttons'];
    //   btnJson.forEach((element) {
    //     buttons.add(Button.fromJson(element));
    //   });
    // }
    return ButtonBase(
      theme: siteInfo['theme'],
      urlChangePeriod: siteInfo['url_chg_period'],
      appNo: siteInfo['app_no'],
      apiKey: siteInfo['api_key'],
      registeredAt: DateTime.parse(siteInfo['reg_dt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'theme': theme,
        'background': background,
        'msgProcess': msgProcess,
        'msgComplete': msgComplete,
        'urlChangePeriod': urlChangePeriod,
        'appNo': appNo,
        'apiKey': apiKey,
        'registeredAt': registeredAt,
        'locale': locale,
      };

  @override
  String toString() => toJson().toString();
}
