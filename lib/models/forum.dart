class forum {
  String? ForumID;
  String? head;
  String? detail;
  String? dateForum;
  String? timeForum;
  String? userFullname;
  String? userId;

  forum(
      {this.ForumID,
      this.head,
      this.detail,
      this.dateForum,
      this.timeForum,
      this.userFullname,
      this.userId});

  forum.fromJson(Map<String, dynamic> json) {
    ForumID = json['ForumID'];
    head = json['Head'];
    detail = json['Detail'];
    dateForum = json['dateForum'];
    timeForum = json['timeForum'];
    userFullname = json['userFullname'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ForumID'] = this.ForumID;
    data['Head'] = this.head;
    data['Detail'] = this.detail;
    data['dateForum'] = this.dateForum;
    data['timeForum'] = this.timeForum;
    data['userFullname'] = this.userFullname;
    data['userId'] = this.userId;
    return data;
  }
}
