class Button {
  int no; // button #
  int? order; // button order
  String label; // button 표시 String
  String? desc; // button 설명
  String? image; // button 이미지
  String? message; // 메시지로 전송될 내용
  String action; // button 처리 방법 (C, M, G, S, U, A, O)
  String? inputType; // sub message input type (T, P, S)
  String? inputTitle; // sub message (P, S)의 경우 물어보는 title
  List<String>? items; // inputType == S 인 경우 열거할 내용
  int flowRule; // flow rule

  Button({
    required this.no,
    this.order,
    required this.label,
    this.desc,
    this.image,
    this.message,
    required this.action,
    this.inputType,
    this.inputTitle,
    this.items,
    required this.flowRule,
  });

  factory Button.fromJson(Map<String, dynamic> json) {
    return Button(
      no: json['no'],
      label: json['name'],
      action: json['division'],
      flowRule: json['flow_rule'],
      order: json['order'],
      desc: json['desc_image'],
      image: json['image'],
      message: json['message'],
      inputType: json['type'],
      inputTitle: json['title'],
    );
  }

  Map<String, dynamic> toJson() => {
        'no': no,
        'label': label,
        'action': action,
        'flowRule': flowRule,
        'order': order,
        'desc': desc,
        'image': image,
        'message': message,
        'inputType': inputType,
        'inputTitle': inputTitle,
      };

  @override
  String toString() => toJson().toString();
}
