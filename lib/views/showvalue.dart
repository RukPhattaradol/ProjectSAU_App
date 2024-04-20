import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_iot/models/iothistory.dart';
import 'package:project_iot/models/iotvalue.dart';
import 'package:project_iot/services/call_api.dart';
import 'package:project_iot/styles.dart';

class ShowValueUI extends StatefulWidget {
  const ShowValueUI({super.key});

  @override
  State<ShowValueUI> createState() => _ShowValueUIState();
}

class _ShowValueUIState extends State<ShowValueUI> {
  List<iotvaluehistory> historyData = [];
  String tempValue = "0";
  String humValue = "0";
  String ultraValue = "0";

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  double getHeight(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    if (_selectedItem == "ทั้งหมด") {
      return screenHeight * 0.7;
    } else {
      return screenHeight * 0.5; // หรือค่าใดๆ ตามที่คุณต้องการ
    }
  }

  Future<void> _fetchHistory() async {
    try {
      final List<iotvaluehistory> data =
          await CallApi.GetHistory(iotvaluehistory());
      setState(() {
        historyData = data;
        historyData.sort((a, b) {
          int dateComparison = b.date!.compareTo(a.date!);
          if (dateComparison != 0) {
            return dateComparison;
          } else {
            return b.time!.compareTo(a.time!);
          }
        });
      });
      //print(historyData);
    } catch (e) {
      print('Error fetching history: $e');
      // Handle error appropriately
    }
  }

  Map<String, int> iotMap = {
    'ทั้งหมด': 0,
    'อุปกรณ์ตัวที่1': 1,
    'อุปกรณ์ตัวที่2': 2,
    'อุปกรณ์ตัวที่3': 3,
    'อุปกรณ์ตัวที่4': 4,
  };
  String _selectedItem = 'ทั้งหมด';

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 4, 18),
      body: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              children: [
                Text(
                  "ข้อมูลอุปกณ์",
                  style: fontstylehaeder.dashboardTextStyle(context),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                DropdownButton<String>(
                  value: _selectedItem,
                  onChanged: (String? newValue) {
                    if (newValue == "ทั้งหมด") {
                      setState(() {
                        _selectedItem = newValue!;
                        _fetchHistory();
                      });
                    } else {
                      setState(() {
                        _selectedItem = newValue!;
                        String iotValueString =
                            iotMap[_selectedItem].toString();
                        //print(iotValueString);
                        iotvaluehistory IotValueHistory =
                            iotvaluehistory(idIot: iotValueString);
                        CallApi.GetHistoryID(IotValueHistory).then((value) {
                          iotvalue IotValue = iotvalue(ID: iotValueString);
                          CallApi.getValueid(IotValue).then((value) {
                            setState(() {
                              tempValue = value.tempValue;
                              humValue = value.humValue;
                              ultraValue = value.ultraValue;
                              print("temp : $tempValue");
                              print("hum : $humValue");
                              print("ultra : $ultraValue");
                            });
                          });
                          setState(() {
                            historyData = value;
                            historyData.sort((a, b) {
                              int dateComparison = b.date!.compareTo(a.date!);
                              if (dateComparison != 0) {
                                return dateComparison;
                              } else {
                                return b.time!.compareTo(a.time!);
                              }
                            });
                          });
                        });
                      });
                    }
                  },
                  items: <String>[
                    "ทั้งหมด",
                    'อุปกรณ์ตัวที่1',
                    'อุปกรณ์ตัวที่2',
                    'อุปกรณ์ตัวที่3',
                    'อุปกรณ์ตัวที่4'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.kanit(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                  dropdownColor: Colors.black,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            ////////////////////////////listข้อมูล////////////////////////////
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, // เปลี่ยนเป็นแนวตั้ง
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // เพิ่มการเลื่อนแนวนอน
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: DataTable(
                      columns: [
                        DataColumn(
                            label: Text('อุปกรณ์',
                                style: fonttablestyle
                                    .dashboardTextStyle(context))),
                        DataColumn(
                            label: Text('ความชื้น',
                                style: fonttablestyle
                                    .dashboardTextStyle(context))),
                        DataColumn(
                            label: Text('อุณหภูมิ',
                                style: fonttablestyle
                                    .dashboardTextStyle(context))),
                        DataColumn(
                            label: Text('ปริมาณน้ำ',
                                style: fonttablestyle
                                    .dashboardTextStyle(context))),
                        DataColumn(
                            label: Text('เวลา',
                                style: fonttablestyle
                                    .dashboardTextStyle(context))),
                        DataColumn(
                            label: Text('วัน',
                                style: fonttablestyle
                                    .dashboardTextStyle(context))),
                      ],
                      // ในส่วนของการแสดง DataTable
                      rows: historyData.map((data) {
                        return DataRow(
                          cells: [
                            DataCell(Text(data.idIot.toString(),
                                style: fonttablestyle
                                    .dashboardTextStyle(context))),
                            DataCell(Text(data.humValue.toString(),
                                style: fonttablestyle
                                    .dashboardTextStyle(context))),
                            DataCell(Text(data.tempValue.toString(),
                                style: fonttablestyle
                                    .dashboardTextStyle(context))),
                            DataCell(Text(
                                data.ultraValue != null
                                    ? data.ultraValue.toString()
                                    : '-',
                                style: fonttablestyle
                                    .dashboardTextStyle(context))),
                            DataCell(Text(data.time ?? '-',
                                style: fonttablestyle
                                    .dashboardTextStyle(context))),
                            DataCell(Text(data.date ?? '-',
                                style: fonttablestyle
                                    .dashboardTextStyle(context))),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              height: getHeight(context),
            ),
            ////////////////////////////listข้อมูล////////////////////////////
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            Visibility(
              visible: !(_selectedItem == "ทั้งหมด"),
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "อุณหภูมิ🌡️ : ${tempValue} องศา",
                      style: fontstyle.dashboardTextStyle(context),
                    ),
                    Text(
                      "ความชื้น💧 : ${humValue} %",
                      style: fontstyle.dashboardTextStyle(context),
                    ),
                    Text(
                      "ระดับน้ำ : ${ultraValue} CM",
                      style: fontstyle.dashboardTextStyle(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
