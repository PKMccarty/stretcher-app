import 'package:http/http.dart' as http;
import 'dart:convert';
import '../user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthHelper {
  static Future<Map<String, dynamic>?> signIn(
      BuildContext context, String username, String password) async {
    String url = "http://192.168.5.133:9999/checklogin.php/";
    final response = await http.post(Uri.parse(url), body: {
      'username': username,
      'password': password,
    });

    var data = json.decode(response.body);
    print(data);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      if (data == "Error") {
        Navigator.pushNamed(context, 'login');

        Fluttertoast.showToast(
          msg: "เข้าสู่ระบบไม่สำเร็จ !!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        return null; // หรือคุณสามารถเกิดข้อผิดพลาดได้
      } else {
        var role = data['role'];
        var role_id = data['role_id'];
        var ward = data['ward'];
        var loginname = data['loginname'];
        var u_image = data['u_image'];
        var name = data['name'];
        var doctorcode = data['doctorcode'];
        var groupname = data['groupname'];
        var accessright = data['accessright'];
        var entryposition = data['entryposition'];
        await User.setsignin(true);

        Navigator.pushNamed(
          context,
          'home',
          arguments: {
            'role_id': role_id,
            'ward': ward,
            'u_id': loginname,
            'u_image': u_image,
            'name': name,
            'doctorcode': doctorcode,
            'groupname': groupname,
            'accessright': accessright,
            'entryposition': entryposition,
          },
        );

        Fluttertoast.showToast(
          msg: "เข้าสู่ระบบสำเร็จ !!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        return data;
      }
    }

    return null;
  }
}
