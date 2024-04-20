import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_iot/models/forum.dart';
import 'package:project_iot/styles.dart';
import 'package:project_iot/services/call_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({Key? key}) : super(key: key);

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  bool usersiconShow = true;
  String userFullname = '';
  String userId = '';
  TextEditingController headtextCtlr = new TextEditingController(text: '');
  TextEditingController subtextCtlr = new TextEditingController(text: '');

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userFullname = prefs.getString('userFullname') ?? '';
      userId = prefs.getString('userId') ?? '';
      print('UserInfo: $userId : $userFullname');
    });
  }

  showWarningMessage(context, msg) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text("คำเตือน",
            style: GoogleFonts.kanit(), textAlign: TextAlign.center),
        content: Text(
          msg,
          style: GoogleFonts.kanit(),
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "ตกลง",
              style: GoogleFonts.kanit(),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  showSuccessMessage(context, msg) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text("สำเร็จ",
            style: GoogleFonts.kanit(), textAlign: TextAlign.center),
        content: Text(
          msg,
          style: GoogleFonts.kanit(),
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              setState(() {
                _fetchForum();
              });
              headtextCtlr.clear(); // ล้างข้อความใน TextEditingController
              subtextCtlr.clear();
            },
            child: Text(
              "ตกลง",
              style: GoogleFonts.kanit(),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  showSuccessMessage2(context, msg) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text("สำเร็จ",
            style: GoogleFonts.kanit(), textAlign: TextAlign.center),
        content: Text(
          msg,
          style: GoogleFonts.kanit(),
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _fetchForum();
              });
              headtextCtlr.clear(); // ล้างข้อความใน TextEditingController
              subtextCtlr.clear();
            },
            child: Text(
              "ตกลง",
              style: GoogleFonts.kanit(),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  _showPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // ป้องกันการปิดพ็อปอัพโดยการแตะพื้นหลัง
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เพิ่มข้อมูล Forum',
              style: fontheadpopuptyle.dashboardTextStyle(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: headtextCtlr,
                decoration: InputDecoration(labelText: 'หัวข้อ'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: subtextCtlr,
                maxLines: 1,
                decoration: InputDecoration(labelText: 'รายละเอียด'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (headtextCtlr.text.isEmpty == true) {
                  showWarningMessage(context, "กรุณากรอกหัวข้อ");
                } else if (subtextCtlr.text.isEmpty == true) {
                  showWarningMessage(context, "กรุณากรอกรายละเอียด");
                } else {
                  forum Forum = forum(
                      head: headtextCtlr.text,
                      detail: subtextCtlr.text,
                      userId: userId);
                  CallApi.InsertForum(Forum).then((value) => {
                        if (value == "1")
                          {showSuccessMessage(context, "บันทึกข้อมูล")}
                        else
                          {showWarningMessage(context, "กรุณาลองใหม่อีกครั้ง")}
                      });
                }
              },
              child: Text(
                'Submit',
                style: GoogleFonts.kanit(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<forum> forumData = [];

  @override
  void initState() {
    super.initState();
    _fetchForum();
    _loadData();
  }

  Future<void> _fetchForum() async {
    try {
      final List<forum> data = await CallApi.GetForum(forum());
      setState(() {
        forumData = data;
        forumData.sort((a, b) => b.dateForum!.compareTo(a.dateForum!));
      });
      //print(forumData);
    } catch (e) {
      print('Error fetching history: $e');
    }
  }

  Future<void> _fetchMyForum() async {
    try {
      final List<forum> data =
          await CallApi.GetFiltterForum(forum(userId: userId));
      setState(() {
        forumData = data;
        forumData.sort((a, b) => b.dateForum!.compareTo(a.dateForum!));
      });
      //print(forumData);
    } catch (e) {
      print('Error fetching history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 4, 18),
      body: SingleChildScrollView(
        child: Padding(
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
              Text(
                "DashBoard",
                style: fontstylehaeder.dashboardTextStyle(context),
              ),
              Text(
                'ยินดีตอนรับสู่แอพ Water Check "${userFullname}"🙏',
                style: GoogleFonts.kanit(
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                children: [
                  Text(
                    'Forum',
                    style: GoogleFonts.kanit(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.58,
                  ),
                  Material(
                    // เพิ่ม Material widget รอบ Icon
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (usersiconShow == true) {
                            usersiconShow = false;
                            _fetchMyForum();
                          } else {
                            usersiconShow = true;
                            _fetchForum();
                          }
                        });
                      },
                      child: Icon(
                        usersiconShow ? Icons.person : Icons.people,
                        color: Colors.white, // กำหนดสีไอคอนเป็นสีขาว
                      ),
                    ),
                  ),
                  Material(
                    // เพิ่ม Material widget รอบ Icon
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _showPopup(context);
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.white, // กำหนดสีไอคอนเป็นสีขาว
                      ),
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              ////////////////////////////listข้อมูล////////////////////////////
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // เปลี่ยนสีขอบตามที่ต้องการ
                    width: 1, // เปลี่ยนความหนาของขอบตามต้องการ
                  ),
                  borderRadius: BorderRadius.circular(
                      10.0), // เพิ่มขอบมนเพื่อทำให้มีมุมโค้ง
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 5.0), // ปรับความสูงของ Padding ตามต้องการ
                  child: ListView.builder(
                    padding: EdgeInsets.zero, // ลบ Padding เดิมของ ListView
                    scrollDirection: Axis.vertical,
                    itemCount: forumData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            forumData[index].head.toString(),
                            style: fonttablestyle.dashboardTextStyle(context),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    forumData[index].detail != null
                                        ? forumData[index].detail.toString()
                                        : '-',
                                    style: fontforumstyle
                                        .dashboardTextStyle(context),
                                  ),
                                  if (forumData[index]
                                          .userFullname
                                          .toString() ==
                                      userFullname)
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          print(forumData[index]
                                              .ForumID
                                              .toString());
                                          forum forumToDelete = forum(
                                              ForumID: forumData[index]
                                                  .ForumID
                                                  .toString());
                                          CallApi.deleteForum(forumToDelete)
                                              .then((value) => setState(() {
                                                    if (usersiconShow == true &&
                                                        value == "1") {
                                                      _fetchMyForum();
                                                      showSuccessMessage2(
                                                          context, "ลบสำเร็จ");
                                                    } else if (usersiconShow ==
                                                            false &&
                                                        value == "1") {
                                                      _fetchForum();
                                                      showSuccessMessage2(
                                                          context, "ลบสำเร็จ");
                                                    } else {
                                                      showSuccessMessage2(
                                                          context,
                                                          "ลบไม่สำเร็จ");
                                                    }
                                                  }));
                                        },
                                        child: Text(
                                          "ลบ",
                                          style: fontforumstyle
                                              .dashboardTextStyle(context),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Text(
                                'เวลา : ${forumData[index].timeForum ?? '-'}',
                                style:
                                    fontforumstyle.dashboardTextStyle(context),
                              ),
                              Text(
                                'วัน : ${forumData[index].dateForum ?? '-'}',
                                style:
                                    fontforumstyle.dashboardTextStyle(context),
                              ),
                              Text(
                                'โดย : ${forumData[index].userFullname ?? '-'}',
                                style:
                                    fontforumstyle.dashboardTextStyle(context),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              ////////////////////////////listข้อมูล///////////////////////////
            ],
          ),
        ),
      ),
    );
  }
}
