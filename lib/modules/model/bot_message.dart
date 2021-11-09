class ChatBotMessage {
  String? text;
  String? image;
  String? linkTo;
  String? postId;

  ChatBotMessage({this.text, this.image, this.linkTo, this.postId});

  ChatBotMessage.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    image = json['image'];
    linkTo = json['linkTo'];
    postId = json['postId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['image'] = this.image;
    data['linkTo'] = this.linkTo;
    data['postId'] = this.postId;
    return data;
  }
}