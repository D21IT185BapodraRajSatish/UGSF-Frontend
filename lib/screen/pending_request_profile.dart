// DAda Ki Jay Ho

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_and_mysql_server/model/user_model.dart';
import 'package:flutter_and_mysql_server/utils/constants.dart';
import 'package:flutter_and_mysql_server/utils/utils.dart';
import 'package:http/http.dart' as http;

class PendingRequestProfile extends StatefulWidget {
  String? onTapedFrom;
  PendingRequestProfile({required this.user, this.onTapedFrom});

  final UserModel user;

  @override
  State<PendingRequestProfile> createState() => _PendingRequestProfileState();
}

class _PendingRequestProfileState extends State<PendingRequestProfile> {
  final storage = FirebaseStorage.instance;

  final storageRef = FirebaseStorage.instance.ref();
  @override
  void initState() {
    print(widget.onTapedFrom ?? "No String found");
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                              child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Image.network(
                              widget.user.profileImageURL,
                              width: 150,
                              height: 150,
                            ),
                          )
                              // FutureBuilder(
                              //     future: storageRef
                              //         .child("ProfileImage.jpg")
                              //         .getDownloadURL(),
                              //     builder: (context, value) {
                              //       return Container(
                              //         margin: const EdgeInsets.symmetric(
                              //             horizontal: 16),
                              //         color: Colors.grey,
                              //         child: value.hasData
                              //             ? Image.network(
                              //                 widget.user.profileImageURL,
                              //                 width: 150,
                              //                 height: 150,
                              //               )
                              //             : null,
                              //       );
                              //     }),
                              ),
                          Expanded(
                              child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Image.network(
                              widget.user.aadharImageURL,
                              width: 150,
                              height: 150,
                            ),
                          )
                              // FutureBuilder(
                              //     future: storageRef
                              //         .child("AadharImage.jpg")
                              //         .getDownloadURL(),
                              //     builder: (context, value) {
                              //       return Container(
                              //         margin: const EdgeInsets.symmetric(
                              //             horizontal: 16),
                              //         child: Image.network(
                              //           widget.user.aadharImageURL,
                              //           width: 150,
                              //           height: 150,
                              //         ),
                              //       );
                              //     }),
                              ),
                        ],
                      ),
                    ),
                    VSpace.lg,
                    Text(widget.user.name,
                        style: const TextStyle(fontSize: 24)),
                  ]),
            ),
            VSpace.med,
            VSpace.lg,
            Text(
              "Date Of Birth: ${widget.user.dob}",
              style: const TextStyle(fontSize: 16),
            ),
            VSpace.med,
            Text(
              "Personal ID : ${widget.user.personalID}",
              style: const TextStyle(fontSize: 16),
            ),
            VSpace.med,
            Text(
              "Address: ${widget.user.address}",
              style: const TextStyle(fontSize: 16),
            ),
            VSpace.med,
            Text(
              "Email : ${widget.user.email}",
              style: const TextStyle(fontSize: 16),
            ),
            VSpace.med,
            Text(
              "Mobile No : ${widget.user.mobileNumber}",
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            FittedBox(
              child: widget.onTapedFrom?.compareTo("PendingList") == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.pushReplacementNamed(context, "/login");
                            http
                                .put(Uri.parse(
                                    "http://$hostname:8070/acceptUserProfile/${widget.user.id}"))
                                .then((value) {
                              Navigator.of(context).pop();
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            elevation: MaterialStateProperty.all(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 8),
                            child: const Text(
                              "Accept ✅",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        HSpace.med,
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.pushReplacementNamed(context, "/login");
                            http
                                .delete(Uri.parse(
                                    "http://$hostname:8070/deleteUserProfile/${widget.user.id}"))
                                .then((value) {
                              Navigator.of(context).pop();
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.redAccent),
                            elevation: MaterialStateProperty.all(8),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 32),
                            child: Text(
                              "Reject   ❌",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      width: size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.pushReplacementNamed(context, "/login");
                          http
                              .delete(Uri.parse(
                                  "http://$hostname:8070/deleteUserProfile/${widget.user.id}"))
                              .then((value) {
                            Navigator.of(context).pop();
                          });
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
