// Dada KI Jay Ho

import 'dart:async';
import 'dart:convert';
import 'package:flutter_and_mysql_server/screen/pendingList.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'acceptedList.dart';
import 'adminProfile.dart';
import 'login.dart';

class AdminHome extends StatefulWidget {
  String? title;
  AdminHome(this.title);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedindex = 0;
  List<Widget> listWidget = [];
  @override
  void initState() {
    // TODO: implement initState
    

    listWidget = [
      PendingList(),
      AcceptedList("AcceptedList"),
      AdminProfile(widget.title),
    ];
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
        actions: [
          IconButton(
              onPressed: () async {
                final SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                _prefs.setBool("isLoginAdmin", false);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: listWidget.elementAt(_selectedindex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Pending",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: "Accepted",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          
        ],
        currentIndex: _selectedindex,
        onTap: (int index) {
          print("User clicked on $index");

          setState(() {
            _selectedindex = index;
            
          });
        },
      ),
    );
  }
}
