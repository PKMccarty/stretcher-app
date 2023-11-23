import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewOne extends StatefulWidget {
  final int jobId;

  ViewOne({required this.jobId});

  @override
  _ViewOneState createState() => _ViewOneState();
}

class _ViewOneState extends State<ViewOne> {
  late Future<Map<String, dynamic>> jobData;

  @override
  void initState() {
    super.initState();
    jobData = fetchJobData(widget.jobId);
  }

  Future<Map<String, dynamic>> fetchJobData(int jobId) async {
    final response = await http.post(
      Uri.parse('http://192.168.5.133:9999/view_alert_one.php'),
      body: {'jobId': jobId.toString()},
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      return json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load job data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Text(
              "CPH ระบบเคลื่อนย้ายผู้ป่วยออนไลน์",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: jobData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No data available');
          } else {
            return SingleChildScrollView(
              child: Container(
                color: Color(0xFFEEEEEE),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(20),
                      width: 400,
                      color: Colors.white,
                      child: SizedBox(
                        child: Text(
                          'รายการร้องขอเคลื่อนย้ายผู้ป่วย',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(20),
                      width: 400,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'HN',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: 10), // ระยะห่างระหว่าง Title กับ Subtitle
                          Text(
                            '${snapshot.data?['hn'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Divider(),
                          Text(
                            'ชื่อ - สกุล',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: 10), // ระยะห่างระหว่าง Title กับ Subtitle
                          Text(
                            '${snapshot.data?['fullname'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Divider(),
                          Text(
                            'จุดรับผู้ป่วย',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: 10), // ระยะห่างระหว่าง Title กับ Subtitle
                          Text(
                            '${snapshot.data?['job_receive'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Divider(),
                          Text(
                            'จุดส่งผู้ป่วย',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: 10), // ระยะห่างระหว่าง Title กับ Subtitle
                          Text(
                            '${snapshot.data?['job_send'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Divider(),
                          Text(
                            'เวลาร้องขอ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: 10), // ระยะห่างระหว่าง Title กับ Subtitle
                          Text(
                            '${snapshot.data?['datejob'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Divider(),
                          Text(
                            'นัดล่วงหน้า',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: 10), // ระยะห่างระหว่าง Title กับ Subtitle
                          Text(
                            '${snapshot.data?['appdate'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Divider(),
                          Text(
                            'อุปกรณ์',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: 10), // ระยะห่างระหว่าง Title กับ Subtitle
                          Text(
                            '${snapshot.data?['waname'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Divider(),
                          Text(
                            'NOTE',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: 10), // ระยะห่างระหว่าง Title กับ Subtitle
                          Text(
                            '${snapshot.data?['job_note'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Divider(),
                          Text(
                            'ความเร่งด่วน',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: 10), // ระยะห่างระหว่าง Title กับ Subtitle
                          Text(
                            '${snapshot.data?['job_priority'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Divider(),
                          Text(
                            'สถานะ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 130,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(
                                  15.0), // Adjust the radius as needed
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  '${snapshot.data?['sta_name'] ?? 'N/A'}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ), // ระยะห่างระหว่าง Title กับ Subtitle
                          Divider(),
                          Container(
                            child: Center(
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        'home',
                                        /*  arguments: {
                                            'role_id': role_id,
                                            'ward': ward,
                                            'u_id': loginname,
                                            'u_image': u_image,
                                            'name': name,
                                            'doctorcode': doctorcode,
                                            'groupname': groupname,
                                            'accessright': accessright,
                                            'entryposition': entryposition,
                                          }, */
                                      );
                                    },
                                    child: Text('รับเคส'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
