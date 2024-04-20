class iotvalue {
  String? ID;
  String? humValue;
  String? tempValue;
  String? ultraValue;
  String? Date;
  String? Time;

  iotvalue(
      {this.ID,
      this.humValue,
      this.tempValue,
      this.ultraValue,
      this.Date,
      this.Time});

  iotvalue.fromJson(Map<String, dynamic> json) {
    ID = json['ID'];
    humValue = json['humValue'];
    tempValue = json['tempValue'];
    ultraValue = json['ultraValue'];
    Date = json['Date'];
    Time = json['Time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.ID;
    data['humValue'] = this.humValue;
    data['tempValue'] = this.tempValue;
    data['ultraValue'] = this.ultraValue;
    data['Date'] = this.Date;
    data['Time'] = this.Time;
    return data;
  }
}
