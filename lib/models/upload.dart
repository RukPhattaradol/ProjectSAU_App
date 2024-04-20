class upload {
  String? userId;
  String? image;

  upload({this.userId, this.image});

  upload.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['image'] = this.image;
    return data;
  }
}
