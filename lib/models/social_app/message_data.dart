class SocialMessageData
{
  late  String senderId;
  late  String receiverId;
  late String text;
  late String dateTime;
  String? image;

  SocialMessageData({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.dateTime,
     this.image,
  });

  Map<String,dynamic> getMessageData(){
    return {
      "senderId": senderId,
      "text": text,
      "receiverId": receiverId,
      "dateTime": dateTime,
      "image":image,
    };
  }
  // named constructor
  SocialMessageData.fromJson(Map<String, dynamic> json)
  {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    text = json['text'];
    dateTime = json['dateTime'];
    image = json['image'];
  }
}

