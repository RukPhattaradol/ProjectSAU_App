import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_iot/models/upload.dart';
import 'package:project_iot/models/user.dart';
import 'package:project_iot/services/call_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:typed_data';

class RegisterUI extends StatefulWidget {
  const RegisterUI({Key? key}) : super(key: key);

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  File? _image;
  bool pwdShow = true;
  bool pwdconShow = true;
  Uint8List? _imageBytes;
  String? _base64String;
  String lastID = "";

  TextEditingController fullnameCtlr = new TextEditingController(text: '');
  TextEditingController usernameCtlr = new TextEditingController(text: '');
  TextEditingController passwordCtlr = new TextEditingController(text: '');
  TextEditingController confirmpasswordCtlr =
      new TextEditingController(text: '');
  TextEditingController ageCtlr = new TextEditingController(text: '');

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        //print('No image selected.');
      }
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

  showsuccessregisMessage(context, msg) async {
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
              upload Upload = upload(
                userId: lastID,
                image: _base64String,
              );
              CallApi.UploadImg(Upload).then((value) => {print(value)});
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

  showInformationMessage(context, msg) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ผลการทำงาน",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Text(
                  'ข้อมูลผู้ใช้งาน',
                  style: GoogleFonts.kanit(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.026,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Stack(
                  children: [
                    _image == null
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/userDefault.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Image.file(
                            _image!,
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.5,
                          ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.06,
                      right: MediaQuery.of(context).size.width * 0.15,
                      child: InkWell(
                        onTap: () async {
                          await _getImage();
                          if (_image != null) {
                            setState(() {
                              _imageBytes =
                                  File(_image!.path).readAsBytesSync();
                              _base64String = base64Encode(_imageBytes!);
                              print(_base64String);
                            });
                          }
                        },
                        child: Icon(
                          Icons.photo,
                          size: MediaQuery.of(context).size.width *
                              0.21, // ขนาดของไอคอนกล้อง
                          color: Colors.grey, // สีของไอคอนกล้อง
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: usernameCtlr,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    hintText: 'username',
                    labelText: 'ชื่อผู้ใช้',
                    hintStyle: GoogleFonts.kanit(color: Colors.white),
                    labelStyle: GoogleFonts.kanit(
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: fullnameCtlr,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    hintText: 'fullname',
                    labelText: 'ชื่อ-สกุล',
                    hintStyle: GoogleFonts.kanit(color: Colors.white),
                    labelStyle: GoogleFonts.kanit(
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: passwordCtlr,
                  obscureText: pwdShow,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    hintText: 'password',
                    labelText: 'รหัสผ่าน',
                    hintStyle: GoogleFonts.kanit(color: Colors.white),
                    labelStyle: GoogleFonts.kanit(
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        //print(pwdShow);
                        setState(() {
                          if (pwdShow == true) {
                            pwdShow = false;
                          } else {
                            pwdShow = true;
                          }
                        });
                      },
                      icon: pwdShow
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: confirmpasswordCtlr,
                  obscureText: pwdconShow,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    hintText: 'confirm password',
                    labelText: 'ยืนยันรหัสผ่าน',
                    hintStyle: GoogleFonts.kanit(color: Colors.white),
                    labelStyle: GoogleFonts.kanit(
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if (pwdconShow == true) {
                            pwdconShow = false;
                          } else {
                            pwdconShow = true;
                          }
                        });
                      },
                      icon: pwdconShow
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                // TextField(
                //   controller: ageCtlr,
                //   keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: BorderSide(
                //         color: Colors.white,
                //       ),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderSide: BorderSide(
                //         color: Colors.white,
                //       ),
                //     ),
                //     hintText: 'Age',
                //     labelText: 'อายุ',
                //     hintStyle: GoogleFonts.kanit(),
                //     labelStyle: GoogleFonts.kanit(
                //       textStyle: TextStyle(
                //         color: Color.fromARGB(255, 134, 13, 5),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'ย้อนกลับ',
                        style: GoogleFonts.kanit(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          MediaQuery.of(context).size.width *
                              0.3, // ปรับค่านี้ตามต้องการ
                          MediaQuery.of(context).size.height *
                              0.06, // ปรับค่านี้ตามต้องการ
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor: Color.fromARGB(255, 105, 105, 105),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.08,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (fullnameCtlr.text.isEmpty == true) {
                          showWarningMessage(
                              context, "กรุณาป้อนชื่อ-สกุลด้วยนะ!");
                        } else if (usernameCtlr.text.isEmpty == true) {
                          showWarningMessage(
                              context, "กรุณาป้อนชื่อผู้ใช้ด้วยนะ!");
                        } else if (passwordCtlr.text.isEmpty == true) {
                          showWarningMessage(context, "กรุณาป้อนรหัสผ่านนะ!");
                        } else if (confirmpasswordCtlr.text.isEmpty == true) {
                          showWarningMessage(
                              context, "กรุณาป้อนยืนยันรหัสผ่านอีกรอบด้วยนะ!");
                        }
                        //else if (ageCtlr.text.isEmpty == true) {showWarningMessage(context, "กรุณาป้อนอายุนะ!");}
                        else if (passwordCtlr == confirmpasswordCtlr) {
                          showWarningMessage(
                              context, "รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกันนะ!");
                        } else {
                          User user = User(
                            userFullname: fullnameCtlr.text,
                            userName: usernameCtlr.text,
                            userAge: ageCtlr.text,
                            userPassword: passwordCtlr.text,
                          );
                          CallApi.InsertUser(user).then((result) => {
                                if (result['message'] == "1")
                                  {
                                    lastID = result['lastId'],
                                    print(result['lastId']),
                                    showsuccessregisMessage(
                                        context, "ลงทะเบียนสำเร็จ")
                                  }
                                else
                                  {
                                    //print(result['lastId']),
                                    showWarningMessage(
                                        context, "กรุณาลองใหม่อีกครั้ง")
                                  }
                              });
                          // upload Upload = upload(
                          //   userId: lastID,
                          //   image: _base64String,
                          // );
                          // CallApi.UploadImg(Upload)
                          //     .then((value) => {print(value)});
                        }
                      },
                      child: Text(
                        'ลงทเบียน',
                        style: GoogleFonts.kanit(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          MediaQuery.of(context).size.width *
                              0.3, // ปรับค่านี้ตามต้องการ
                          MediaQuery.of(context).size.height *
                              0.06, // ปรับค่านี้ตามต้องการ
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor: Colors.white,
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
