import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_and_mysql_server/model/admin_model.dart';

import 'package:flutter_and_mysql_server/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class AdminProfile extends StatefulWidget {
  String? userID;
  AdminProfile(this.userID);

  @override
  
  State<AdminProfile> createState() => _AdminProfileState();
  
  
}

class _AdminProfileState extends State<AdminProfile> {
  //=new AdminModel("","","","",0,"","","",);
  AdminModel? adminModel;
  @override

  bool get mounted => adminModel != null;
  void initState() {
    //TODO: implement initState
//print(widget.userID ?? "Not able to print");
    http
        .get(Uri.parse("http://$hostname:8070/getAdmin/${widget.userID}"))
        .then((value) {
      setState(() {
        
        adminModel = AdminModel.fromJson(jsonDecode(value.body));
      });
    });
    print(adminModel?.name ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    //     Container(
                    //   margin: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: adminModel != null
                    //       ? Image.network(
                    //           adminModel!.profileImageURL,
                    //           width: 150,
                    //           height: 150,
                    //         )
                    //       : Container(),
                    // ),
                    VSpace.lg,
                    Text(adminModel?.name ?? "",
                        style: TextStyle(fontSize: 24)),
                  ]),
            ),
            VSpace.med,
            VSpace.lg,
            Text(
              "Date Of Birth: ${adminModel?.dob ?? ""}",
              style: const TextStyle(fontSize: 16),
            ),
            VSpace.med,
            Text(
              "Personal ID : ${adminModel?.personalID ?? ""}",
              style: const TextStyle(fontSize: 16),
            ),
            VSpace.med,
            Text(
              "Address: ${adminModel?.address ?? ""}",
              style: const TextStyle(fontSize: 16),
            ),
            VSpace.med,
            Text(
              "Email : ${adminModel?.email ?? ""}",
              style: const TextStyle(fontSize: 16),
            ),
            VSpace.med,
            Text(
              "Mobile No : ${adminModel?.mobileNumber}",
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, "/login");
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                  elevation: MaterialStateProperty.all(8),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
