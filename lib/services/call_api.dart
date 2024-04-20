import 'dart:convert';

import 'package:project_iot/models/chatAI.dart';
import 'package:project_iot/models/forum.dart';
import 'package:project_iot/models/iothistory.dart';
import 'package:project_iot/models/iotvalue.dart';
import 'package:project_iot/models/upload.dart';
import 'package:project_iot/models/user.dart';
import 'package:project_iot/utils/host.dart';
import 'package:http/http.dart' as http;

class CallApi {
  static Future CheckLogin(User user) async {
    final response = await http.post(
      Uri.parse(
          Host.hostUrl + "/projectapi/app/apis/user/check_login_user_api.php"),
      body: jsonEncode(user.toJson()),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = User.fromJson(responseData);
      return data;
    } else {
      throw Exception('Fail....');
    }
  }

  static Future getValueid(iotvalue IotValue) async {
    final response = await http.post(
      Uri.parse(Host.hostUrl + "/projectapi/app/apis/iotvalue/getvalueid.php"),
      body: jsonEncode(IotValue.toJson()),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = iotvalue.fromJson(responseData);
      return data;
    } else {
      throw Exception('Fail....');
    }
  }

  static Future<Map<String, dynamic>> AIrequest(chatAI ChatGPT) async {
    final response = await http.post(
      Uri.parse(Host.hostUrl + "/ai.php"),
      body: jsonEncode(ChatGPT.toJson()),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final content = responseData['content'];
      return {
        'content': content,
      };
    } else {
      throw Exception('Fail....');
    }
  }
  // static Future AIrequest(chatAI ChatGPT) async {
  //   final response = await http.post(
  //     Uri.parse(Host.hostUrl + "/ai.php"),
  //     body: jsonEncode(ChatGPT.toJson()),
  //     headers: {'content-type': 'application/json'},
  //   );

  //   if (response.statusCode == 200) {
  //     final responseData = jsonDecode(response.body);
  //     final content = responseData['content'];
  //     return {
  //       'content': content,
  //     };
  //   } else {
  //     throw Exception('Fail....');
  //   }
  // }

  static Future<Map<String, dynamic>> InsertUser(User user) async {
    final response = await http.post(
      Uri.parse(Host.hostUrl + "/projectapi/app/apis/user/insert_user_api.php"),
      body: jsonEncode(user.toJson()),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final lastId = responseData['lastId'];
      final message = responseData['message'];
      return {'message': message, 'lastId': lastId};
    } else {
      throw Exception('Fail....');
    }
  }

  static Future<List<iotvaluehistory>> GetHistory(
      iotvaluehistory IotValueHistory) async {
    final response = await http.post(
      Uri.parse(
          Host.hostUrl + "/projectapi/app/apis/iotvalue/getallhistory.php"),
      body: jsonEncode(IotValueHistory.toJson()),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      final List<iotvaluehistory> dataList =
          responseData.map((json) => iotvaluehistory.fromJson(json)).toList();
      return dataList;
    } else {
      throw Exception('Fail....');
    }
  }

  static Future<List<iotvaluehistory>> GetHistoryID(
      iotvaluehistory IotValueHistory) async {
    final response = await http.post(
      Uri.parse(Host.hostUrl + "/projectapi/app/apis/iotvalue/gethistory.php"),
      body: jsonEncode(IotValueHistory.toJson()),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      final List<iotvaluehistory> dataList =
          responseData.map((json) => iotvaluehistory.fromJson(json)).toList();
      return dataList;
    } else {
      throw Exception('Fail....');
    }
  }

//ดึงข้อมูลForum
  static Future<List<forum>> GetForum(forum Forum) async {
    final response = await http.post(
      Uri.parse(Host.hostUrl + "/projectapi/app/apis/forum/get_forum_api.php"),
      body: jsonEncode(Forum.toJson()),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      final List<forum> dataList =
          responseData.map((json) => forum.fromJson(json)).toList();
      return dataList;
    } else {
      throw Exception('Fail....');
    }
  }

  static Future InsertForum(forum Forum) async {
    final response = await http.post(
      Uri.parse(
          Host.hostUrl + "/projectapi/app/apis/forum/insert_forum_api.php"),
      body: jsonEncode(Forum.toJson()),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['message'];
    } else {
      throw Exception('Fail....');
    }
  }

  static Future<List<forum>> GetFiltterForum(forum Forum) async {
    final response = await http.post(
      Uri.parse(
          Host.hostUrl + "/projectapi/app/apis/forum/filter_forum_api.php"),
      body: jsonEncode(Forum.toJson()),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      final List<forum> dataList =
          responseData.map((json) => forum.fromJson(json)).toList();
      return dataList;
    } else {
      throw Exception('Fail....');
    }
  }

  static Future deleteForum(forum Forum) async {
    final response = await http.post(
      Uri.parse(
          Host.hostUrl + "/projectapi/app/apis/forum/delete_forum_api.php"),
      body: jsonEncode(Forum.toJson()),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['message'];
    } else {
      throw Exception('Fail....');
    }
  }

  static Future UploadImg(upload Upload) async {
    final response = await http.post(
      Uri.parse(Host.hostUrl + "/upload_user_api.php"),
      body: jsonEncode(Upload.toJson()),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['message'];
    } else {
      throw Exception('Fail....');
    }
  }
}
