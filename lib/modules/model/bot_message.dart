class ChatBotMessage {
  String? text;
  String? image;
  String? linkTo;
  List<String>? postIds;
  String? type;

  ChatBotMessage({this.text, this.image, this.linkTo, this.postIds});

  ChatBotMessage.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    image = json['image'];
    linkTo = json['linkTo'];
    if (json['postId'] != null) {
      postIds = (json['postId'] as List).map((e) => e.toString()).toList();
    }
    type = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['image'] = this.image;
    data['linkTo'] = this.linkTo;
    data['postId'] = this.postIds;
    return data;
  }
}
