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
