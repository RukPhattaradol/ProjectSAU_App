import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_iot/styles.dart';
import 'package:project_iot/views/login_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserUI extends StatefulWidget {
  const UserUI({Key? key}) : super(key: key);

  @override
  State<UserUI> createState() => _UserUIState();
}

class _UserUIState extends State<UserUI> {
  String userFullname = '';
  String ImgPaht = '';

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userFullname = prefs.getString('userFullname') ?? '';
      ImgPaht = prefs.getString('ImgPaht') ?? '';
      print('UserInfo: : $userFullname');
      print('ImgPath: : $ImgPaht');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 4, 18),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              ClipOval(
                child: Image.network(
                  'http://s6419c10006.sautechnology.com$ImgPaht',
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.2,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Text('Error loading image');
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "${userFullname}",
                style: fontstyle.dashboardTextStyle(context),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ElevatedButton(
                onPressed: () {
                  GetStorage().erase();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginUI(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50),
                  side: BorderSide(width: 2, color: Colors.white),
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  "ออกจากระบบ",
                  style: fontbuttonstyle.dashboardTextStyle(context),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ElevatedButton(
                onPressed: () {
                  exit(0);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50),
                  side: BorderSide(width: 2, color: Colors.white),
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  "ออกจากแอพ",
                  style: fontbuttonstyle.dashboardTextStyle(context),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            ],
          ),
        ),
      ),
    );
  }
}
