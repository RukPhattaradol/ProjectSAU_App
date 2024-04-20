class User {
  String? message;
  String? userId;
  String? userFullname;
  String? userName;
  String? userPassword;
  String? userAge;
  String? ImgPaht;
  String? lastId;

  User(
      {this.message,
      this.userId,
      this.userFullname,
      this.userName,
      this.userPassword,
      this.userAge,
      this.ImgPaht,
      this.lastId});

  User.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userId = json['userId'];
    userFullname = json['userFullname'];
    userName = json['userName'];
    userPassword = json['userPassword'];
    userAge = json['userAge'];
    ImgPaht = json['ImgPaht'];
    lastId = json['lastId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['userId'] = this.userId;
    data['userFullname'] = this.userFullname;
    data['userName'] = this.userName;
    data['userPassword'] = this.userPassword;
    data['userAge'] = this.userAge;
    data['ImgPaht'] = this.ImgPaht;
    data['lastId'] = this.message;
    return data;
  }
}
