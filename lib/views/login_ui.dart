import 'dart:ui';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_iot/main.dart';
import 'package:project_iot/models/user.dart';
import 'package:project_iot/services/call_api.dart';
import 'package:project_iot/views/register_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  bool isChecked = false;
  bool pwdShow = true;
  String userFullname = "0";
  String userId = "0";
  String ImgPaht = "0";

  TextEditingController usernameCtlr = new TextEditingController(text: '');
  TextEditingController passwordCtlr = new TextEditingController(text: '');

  Future<void> _saveData(
      String userFullname, String userId, String ImgPaht) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userFullname', userFullname);
    prefs.setString('userId', userId);
    prefs.setString('ImgPaht', ImgPaht);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 4, 18),
      // appBar: AppBar(
      //   backgroundColor: Color.fromARGB(255, 159, 0, 0),
      //   title: Text(
      //     "IoT SAU 2024",
      //     style: GoogleFonts.kanit(
      //       color: Colors.white,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.1,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.15,
                ),
                Image.asset(
                  "assets/images/logo.png",
                  width: MediaQuery.of(context).size.width * 0.65,
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.005,
                // ),
                Text(
                  "เข้าใช้งานแอปพลิเคชั่น",
                  style: GoogleFonts.kanit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.06,
                ),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: usernameCtlr,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: "username",
                    labelText: "ชื่อผู้ใช้",
                    hintStyle: GoogleFonts.kanit(color: Colors.white),
                    labelStyle: GoogleFonts.kanit(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.03,
                ),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: passwordCtlr,
                  obscureText: pwdShow,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: "password",
                    labelText: "รหัสผ่าน",
                    hintStyle: GoogleFonts.kanit(color: Colors.white),
                    labelStyle: GoogleFonts.kanit(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if (pwdShow == true) {
                            pwdShow = false;
                          } else {
                            pwdShow = true;
                          }
                        }); //setState ใช้ตอนมีผลกับหน้าจอ
                      },
                      icon: pwdShow
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // จัดวางตรงกลางแนวตั้ง
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          Text(
                            'Remember me',
                            style: GoogleFonts.kanit(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (usernameCtlr.text.isEmpty == true) {
                        showWarningMessage(context, "กรุณากรอกชื่อผู้ใช้นะ!");
                      } else if (passwordCtlr.text.isEmpty == true) {
                        showWarningMessage(context, "กรุณากรอกรหัสผ่านนะ!");
                      } else {
                        User user = User(
                            userName: usernameCtlr.text,
                            userPassword: passwordCtlr.text);

                        CallApi.CheckLogin(user).then((value) {
                          if (value.message == "1") {
                            GetStorage().write('user', usernameCtlr.text);
                            GetStorage().write('isCheckbox', isChecked);
                            _saveData(value.userFullname, value.userId,
                                    value.ImgPaht)
                                .then((_) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyHomePage(),
                                ),
                              );
                              print(value.ImgPaht);
                            });
                          } else {
                            showWarningMessage(
                                context, "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง");
                          }
                        });
                      }
                    },
                    child: Text(
                      "Log in",
                      style: GoogleFonts.kanit(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height * 0.07,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      backgroundColor: Colors.white,
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.08,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Do not have account? ",
                      style: GoogleFonts.kanit(
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterUI(),
                          ),
                        );
                      },
                      child: Text(
                        "Register ",
                        style: GoogleFonts.kanit(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 159, 0, 0)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
