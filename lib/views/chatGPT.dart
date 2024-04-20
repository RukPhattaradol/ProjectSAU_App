import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class chatGPT extends StatefulWidget {
  const chatGPT({Key? key}) : super(key: key);

  @override
  State<chatGPT> createState() => _chatGPTState();
}

class _chatGPTState extends State<chatGPT> {
  String _weatherInfo = '';
  TextEditingController _textcontroller = TextEditingController();
  String youtext = '';

  Future<void> _fetchData() async {
    var url = Uri.parse('http://s6419c10006.sautechnology.com/ai.php');
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'question': '${_textcontroller.text}',
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data is List && data.isNotEmpty) {
        setState(() {
          _weatherInfo = data[0]['content'];
          print(_weatherInfo);
          print(_textcontroller.text);
        });
      } else {
        setState(() {
          _weatherInfo = 'No weather information available';
        });
      }
    } else {
      setState(() {
        _weatherInfo = 'Failed to fetch weather information';
      });
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
                "Chat AI",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.brown, width: 2.0),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    " ChatGPT : $_weatherInfo",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.04,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.brown, width: 2.0),
                ),
                child: Center(
                  child: Text(
                    "คุณ : ${youtext}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      // เพิ่ม SinglechildScrollView ตรงนี้
                      child: TextField(
                        controller: _textcontroller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'พิมพ์ข้อความของคุณที่นี่...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _fetchData();
                      setState(() {
                        youtext = "${_textcontroller.text}";
                      });
                      _textcontroller.clear();
                    },
                    icon: Icon(Icons.send),
                    color: Colors.blue,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
