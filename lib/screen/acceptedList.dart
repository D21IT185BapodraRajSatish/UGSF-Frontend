// dadakijayho
import 'package:flutter/material.dart';
import 'package:flutter_and_mysql_server/model/user_model.dart';
import 'package:flutter_and_mysql_server/screen/pending_request_profile.dart';
import 'package:flutter_and_mysql_server/utils/constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

class AcceptedList extends StatefulWidget {
  String? currentPage;
  AcceptedList(this.currentPage);

  @override
  State<AcceptedList> createState() => _AcceptedListState();
}

class _AcceptedListState extends State<AcceptedList> {
  List<UserModel> consumerList = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    http.get(Uri.parse("http://$hostname:8070/getAcceptedList")).then((value) {
      print(value.body);
      consumerList.clear();
      setState(() {
        List<dynamic> jsonList = jsonDecode(value.body);
        for (var each in jsonList) {
          consumerList.add(UserModel.fromJson(each));
        }
      });
    }).catchError((e) => print(e));
    const oneSec = Duration(seconds: 15);
    Timer.periodic(oneSec, (Timer t) {
      http
          .get(Uri.parse("http://$hostname:8070/getAcceptedList"))
          .then((value) {
        print(value.body);
        consumerList.clear();
        setState(() {
          List<dynamic> jsonList = jsonDecode(value.body);
          for (var each in jsonList) {
            consumerList.add(UserModel.fromJson(each));
          }
        });
      }).catchError((e) => print(e));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: consumerList.length,
              itemBuilder: (context, index) {
                final item = consumerList[index];
                return ListTile(
                  title: Text(consumerList[index].name),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return PendingRequestProfile(user: consumerList[index],onTapedFrom : widget.currentPage);
                      }),
                    ).then((value) {
                      http
                          .get(Uri.parse(
                              "http://$hostname:8070/getAcceptedList"))
                          .then((value) {
                        print(value.body);
                        consumerList.clear();
                        setState(() {
                          List<dynamic> jsonList = jsonDecode(value.body);
                          for (var each in jsonList) {
                            consumerList.add(UserModel.fromJson(each));
                          }
                        });
                      }).catchError((e) => print(e));
                    });
                  },
                  // trailing: SizedBox(
                  //   width: 100,
                  //   child: FittedBox(
                  //       child: Row(
                  //     children: [
                  //       //OutlinedButton(onPressed: onPressed, child: child)
                  //       OutlinedButton(
                  //           onPressed: () {
                  //             http
                  //                 .delete(Uri.parse(
                  //                     "http://$hostname:8070/delete/" +
                  //                         consumerList[index].id.toString()))
                  //                 .then((value) {
                  //               print("\n" + value.body);
                  //               consumerList.clear();
                  //               setState(() {
                  //                 List<dynamic> jsonList =
                  //                     jsonDecode(value.body);
                  //                 for (var each in jsonList) {
                  //                   consumerList.add(UserModel.fromJson(each));
                  //                 }
                  //               });
                  //             }).catchError((e) => print(e));
                  //           },
                  //           child: const Text("DELETE"))
                  //     ],
                  //   )),
                  // ),
                );
              }),
        ),
      ],
    ));
  }
}
