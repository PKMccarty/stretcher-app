import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:webmanage/page/view_two.dart';
import 'dart:convert';
import '../user.dart';
import 'view_one.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    NotificationsPage(),
    NewPatientPage(),
    ListPage(),
    StatisticsPage(),
  ];

  @override
  Future clicklogout() async {
    await User.setsignin(false);
    Navigator.pushNamed(context, 'login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logo/cph.png',
                height: 40,
              ),
            ),
            Text(
              "CPH ระบบเคลื่อนย้ายผู้ป่วยออนไลน์",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
        actions: [
          // Add a dropdown button for logout with an icon
          PopupMenuButton<int>(
            onSelected: (value) {
              if (value == 1) {
                clicklogout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 1,
                child: ListTile(
                  leading: Icon(Icons.exit_to_app), // Add your desired icon
                  title: Text('Logout'),
                ),
              ),
              // Add more menu items as needed
            ],
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.purple,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_sharp),
            label: 'แจ้งเตือน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'ผู้ป่วยใหม่',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'รายการ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'สถิติ',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Extract the arguments
    Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print("Arguments: $args");
    // Check if args is not null
    if (args != null) {
      // Access the values

      var role = args['role'];
      var role_id = args['role_id'];
      var ward = args['ward'];
      var loginname = args['loginname'];
      var u_image = args['u_image'];
      var name = args['name'];
      var doctorcode = args['doctorcode'];
      var groupname = args['groupname'];
      var accessright = args['accessright'];
      var entryposition = args['entryposition'];
      // Access other values as needed

      return Column(
        children: [
          // Card at the top
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(CupertinoIcons.plus_square_on_square),
              title: Text('รายการร้องขอใหม่'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewTwo(),
                  ),
                );
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(CupertinoIcons.hourglass),
              title: Text('รายการกำลังดำเนินการ'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewTwo(),
                  ),
                );
              },
            ),
          ),

          // Add any additional widgets or UI components as needed
        ],
      );
    } else {
      // Handle the case where arguments are missing or incorrect
      return Center(
        child: Text('ข้อมูลไม่ถูกต้อง'),
      );
    }
  }
}

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List viewalert = [];
  final StreamController<List> _streamController = StreamController<List>();

  @override
  void initState() {
    super.initState();
    // Initialize the stream when the widget is created
    getviewalert();
  }

  Stream<List> get viewAlertStream => _streamController.stream;

  // Fetch data and add it to the stream
  Future<void> getviewalert() async {
    String url = "http://192.168.5.133:9999/view_alert.php";
    try {
      while (true) {
        var response = await http.get(Uri.parse(url));
        List newData = jsonDecode(response.body);
        // Add the new data to the stream
        _streamController.add(newData);
        // Wait for a short time before fetching new data
        await Future.delayed(Duration(seconds: 10));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List>(
        stream: viewAlertStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Add a loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Use the latest data from the stream
            viewalert = snapshot.data ?? [];
            return ListView.builder(
              itemCount: viewalert.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(CupertinoIcons.bell_circle),
                    title: Text('ร้องขอเคลื่อนย้ายผู้ป่วย'),
                    subtitle: Text('แผนก ' +
                        viewalert[index]['job_receive'] +
                        ' เคลื่อนย้ายผู้ป่วย \n HN:  ' +
                        viewalert[index]['hn'] +
                        ' ไปยัง ' +
                        viewalert[index]['job_send']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewOne(
                            jobId: viewalert[index]['job_id'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _streamController.close(); // Close the stream when the widget is disposed
    super.dispose();
  }
}

class NewPatientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('หน้ารายการ'),
    );
  }
}

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('หน้าสถิติ'),
    );
  }
}
