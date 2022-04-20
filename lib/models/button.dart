class Button {
  String id; // button #
  String title; // button 표시 String
  String? image; // button 이미지
  String? desc; // button 설명
  int? order; // button order
  String? message; // 메시지로 전송될 내용
  String actionId; // button 처리 방법 (C, M, G, S, U, A, O)
  ButtonAction action;
  String? inputTypeId; // sub message input type (T, P, S)

  Button({
    required this.id,
    required this.title,
    this.image,
    this.desc,
    this.order,
    this.message,
    required this.actionId,
    required this.action,
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
      action: ButtonAction.fromJson(json['action']),
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
        'action': action.toJson(),
        'inputTypeId': inputTypeId,
      };

  @override
  String toString() => toJson().toString();
}

class ButtonAction {
  String typename;
  String? title;
  String? message;
  String? image;
  String? url;
  UserInput? userinput;

  ButtonAction({
    required this.typename,
    this.title,
    this.message,
    this.image,
    this.url,
    this.userinput,
  });

  factory ButtonAction.fromJson(Map<String, dynamic> json) {
    return ButtonAction(
      typename: json['__typename'],
      title: json['title'],
      message: json['message'],
      image: json['image'],
      url: json['url'],
      userinput: json['userinput'] == null
          ? null
          : UserInput.fromJson(json['userinput']),
    );
  }

  Map<String, dynamic> toJson() => {
        '__typename': typename,
        'title': title,
        'message': message,
        'image': image,
        'url': url,
        'userinput': userinput?.toJson(),
      };

  @override
  String toString() => toJson().toString();
}

class UserInput {
  String typename;
  String? title;
  String? text;
  List<String>? items;

  UserInput({
    required this.typename,
    this.title,
    this.text,
    this.items,
  });

  factory UserInput.fromJson(Map<String, dynamic> json) {
    List<String>? items;
    if (json['items'] != null) {
      // print('user input conversion ${json['items']}');
      items = [];
      for (int i = 0; i < json['items'].length; i++) {
        items.add(json['items'][i]);
      }
      // print(items);
    }
    return UserInput(
      typename: json['__typename'],
      title: json['title'],
      text: json['text'],
      items: items,
    );
  }

  Map<String, dynamic> toJson() => {
        '__typename': typename,
        'title': title,
        'text': text,
        'items': items,
      };

  @override
  String toString() => toJson().toString();
}
