import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_and_mysql_server/model/user_model.dart';
import 'package:flutter_and_mysql_server/utils/constants.dart';
import 'package:flutter_and_mysql_server/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class UserHome extends StatefulWidget {
  String? userID;
  UserHome(this.userID);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  UserModel? userModel;
  @override
  void initState() {
    // TODO: implement initState
    print(widget.userID);
    http
        .get(Uri.parse(
            "http://$hostname:8070/getSpecificConsumer/${widget.userID}"))
        .then((value) {
      print(value);
      setState(() {
        userModel = UserModel.fromJson(jsonDecode(value.body));
      });
    });
    print(userModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumer Home"),
        actions: [
          IconButton(
              onPressed: () async {
                final SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                _prefs.setBool("isLoginForConsumer", false);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: userModel != null
                      ? Image.network(
                          userModel!.profileImageURL,
                          width: 150,
                          height: 150,
                        )
                      : Container(),
                ),
                VSpace.lg,
                Text(userModel?.name ?? " ",
                    style: const TextStyle(fontSize: 24)),
              ],
            ),
          ),
          VSpace.med,
          VSpace.lg,
          Text(
            "Date Of Birth: ${userModel?.dob ?? ""}",
            style: const TextStyle(fontSize: 16),
          ),
          VSpace.med,
          Text(
            "Personal ID : ${userModel?.personalID ?? ""}",
            style: const TextStyle(fontSize: 16),
          ),
          VSpace.med,
          Text(
            "Address: ${userModel?.address ?? ""}",
            style: const TextStyle(fontSize: 16),
          ),
          VSpace.med,
          Text(
            "Email : ${userModel?.email ?? ""}",
            style: const TextStyle(fontSize: 16),
          ),
          VSpace.med,
          Text(
            "Mobile No : ${userModel?.mobileNumber ?? ""}",
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            "Capital Account Balance : ${"4435673"}",
            style: const TextStyle(fontSize: 16),
          ),
        ]),
      ),
    );
  }
}
