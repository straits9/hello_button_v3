class Button {
  String id; // button #
  String title; // button 표시 String
  String? image; // button 이미지
  String? desc; // button 설명
  int? order; // button order
  String? message; // 메시지로 전송될 내용
  String actionId; // button 처리 방법 (C, M, G, S, U, A, O)
  String? inputTypeId; // sub message input type (T, P, S)

  Button({
    required this.id,
    required this.title,
    this.image,
    this.desc,
    this.order,
    this.message,
    required this.actionId,
    this.inputTypeId,
  });

  factory Button.fromJson(Map<String, dynamic> json) {
    return Button(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      desc: json['desc'],
      order: json['order'],
      message: json['message'],
      actionId: json['actionId'],
      inputTypeId: json['inputTypeId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'desc': desc,
        'order': order,
        'message': message,
        'actionId': actionId,
        'inputTypeId': inputTypeId,
      };

  @override
  String toString() => toJson().toString();
}
