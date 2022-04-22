import 'package:hello_button_v3/models/button.dart';

class Site {
  String id;
  String name;
  String? desc;
  String? country;
  String? tz;
  String? locale;
  bool useButton;
  String? theme;
  String? background;
  String? logo;
  List<Button>? buttons;
  int? validWithin;

  Site({
    required this.id,
    required this.name,
    this.desc,
    this.tz,
    this.locale,
    this.useButton = false,
    this.theme,
    this.background,
    this.logo,
    this.buttons,
    this.validWithin,
  });

  factory Site.fromJson(Map<String, dynamic> json) {
    List<Button> buttons = [];
    if (json['buttons'] != null && json['buttons'] is List) {
      for (var i = 0; i < json['buttons'].length; i++) {
        var button = json['buttons'][i];
        Button btn = Button.fromJson(button);
        buttons.add(btn);
      }
    }

    return Site(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      tz: json['tz'],
      locale: json['locale'] ?? 'ko-KR',
      useButton: json['useButton'],
      theme: json['theme'],
      background: json['background'],
      logo: json['logo'],
      validWithin: json['validWithin'],
      buttons: buttons,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'desc': desc,
        'tz': tz,
        'locale': locale,
        'useButton': useButton,
        'theme': theme,
        'background': background,
        'logo': logo,
        'validWithin': validWithin,
        'buttons': buttons,
      };

  @override
  String toString() => toJson().toString();
}
