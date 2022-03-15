class Site {
  int? no;
  String? name;
  bool useButton;
  String? locale;

  Site({this.no, this.name, this.useButton = false, this.locale});

  Site.fromJson(Map<String, dynamic> json)
      : no = json['store_no'],
        name = json['name'],
        useButton = json['use_hellobutton_yn'] == 'Y',
        locale = json['locale'] ?? 'ko-KR';

  Map<String, dynamic> toJson() => {
        'store_no': no,
        'name': name,
        'use_hellobutton_yn': useButton ? 'Y' : 'N',
        'locale': locale,
      };

  @override
  String toString() => toJson().toString();
}
