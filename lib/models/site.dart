class Site {
  int no;
  String name;
  bool useButton;
  String? locale;

  Site(
      {required this.no,
      required this.name,
      required this.useButton,
      this.locale});

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
