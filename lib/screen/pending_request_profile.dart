// DAda Ki Jay Ho

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_and_mysql_server/model/user_model.dart';
import 'package:flutter_and_mysql_server/utils/utils.dart';

class PendingRequestProfile extends StatelessWidget {
  PendingRequestProfile({super.key, required this.user});

  final UserModel user;

  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumer Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Row(
                        children: [
                          Expanded(
                            child: FutureBuilder(
                                future: storageRef
                                    .child("ProfileImage.jpg")
                                    .getDownloadURL(),
                                builder: (context, value) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    color: Colors.grey,
                                    child: value.hasData
                                        ? Image.network(value.data!)
                                        : null,
                                  );
                                }),
                          ),
                          Expanded(
                            child: FutureBuilder(
                                future: storageRef
                                    .child("AadharImage.jpg")
                                    .getDownloadURL(),
                                builder: (context, value) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    color: Colors.grey,
                                    child: value.hasData
                                        ? Image.network(value.data!)
                                        : null,
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                    VSpace.lg,
                    Text(user.name, style: const TextStyle(fontSize: 24)),
                  ]),
            ),
            VSpace.med,
            VSpace.lg,
            Text(
              "Date Of Birth: not provided",
              style: TextStyle(fontSize: 16),
            ),
            VSpace.med,
            Text(
              "Personal ID : ${user.personalID}",
              style: TextStyle(fontSize: 16),
            ),
            VSpace.med,
            Text(
              "Address: ${user.address}",
              style: TextStyle(fontSize: 16),
            ),
            VSpace.med,
            Text(
              "Email : ${user.email}",
              style: TextStyle(fontSize: 16),
            ),
            VSpace.med,
            Text(
              "Mobile No : ${user.mobilePhone}",
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.pushReplacementNamed(context, "/login");
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      elevation: MaterialStateProperty.all(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 8),
                      child: const Text(
                        "Accept ✅",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  HSpace.med,
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.pushReplacementNamed(context, "/login");
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent),
                      elevation: MaterialStateProperty.all(8),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                      child: Text(
                        "Reject   ❌",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
}
