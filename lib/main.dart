import 'package:flutter/material.dart';
import 'package:webmanage/check_login.dart';
import 'package:webmanage/login.dart';
import 'package:webmanage/page/home.dart';
import 'package:webmanage/page/view_two.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPH ระบบเคลื่อนย้ายผู้ป่วยออนไลน์',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: check_login(), // หน้าจอหลักเมื่อแอปเริ่มต้น
      routes: {
        'home': (context) => HomeScreen(), // เส้นทางสำหรับหน้า home
        'login': (context) => login(),
        'ViewTwo': (context) => ViewTwo(), // เส้นทางสำหรับหน้า login
      },
    );
  }
}
