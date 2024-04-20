class iotvaluehistory {
  String? idIot;
  String? humValue;
  String? tempValue;
  String? ultraValue;
  String? date;
  String? time;

  iotvaluehistory(
      {this.idIot,
      this.humValue,
      this.tempValue,
      this.ultraValue,
      this.date,
      this.time});

  iotvaluehistory.fromJson(Map<String, dynamic> json) {
    idIot = json['idIot'];
    humValue = json['humValue'];
    tempValue = json['tempValue'];
    ultraValue = json['ultraValue'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idIot'] = this.idIot;
    data['humValue'] = this.humValue;
    data['tempValue'] = this.tempValue;
    data['ultraValue'] = this.ultraValue;
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}
