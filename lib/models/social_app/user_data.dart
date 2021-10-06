class SocialUserData
{
  late  String name;
  late  String email;
  late String phone;
  String? bio;
  String? image;

  SocialUserData({
    required this.name,
    required this.email,
    required this.phone,
    bio,
    image,
});

  Map<String,dynamic> getUserData(){
    return {
      "name": name,
      "phone": phone,
      "email": email,
      "bio" : bio,
      "image": image,
    };
  }
  // named constructor
  SocialUserData.fromJson(Map<String, dynamic> json)
  {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    bio= json["bio"];
    image = json["image"];
  }
}

