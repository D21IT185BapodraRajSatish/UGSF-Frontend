import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_and_mysql_server/screen/UserHome.dart';

import 'package:flutter_and_mysql_server/screen/registration.dart';
import 'package:flutter_and_mysql_server/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'adminhome.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  String adminRegister = "addAdmin";
  String userRegister = "addConsumer";
  


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _useIDController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setLoginInSharedPreferenceForAdmin(bool loginState) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setBool('isLoginAdmin', loginState).then((bool success) {
        return loginState;
      });
    });
  }

  Future<void> setLoginInSharedPreferenceForConsumer(bool loginState) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setBool('isLoginForConsumer', loginState).then((bool success) {
        return loginState;
      });
    });
  }
  
  @override
  void initState()  {
    // TODO: implement initState
      
    

    _prefs.then((mySharedPreference) {
      if (mySharedPreference.getBool("islogin") == null) {
        mySharedPreference.setBool("islogin", false);
      } else if (mySharedPreference.getBool("islogin")! == true) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AdminHome(_useIDController.text)));
      }
    });

    _prefs.then((mySharedPreference) {
      if (mySharedPreference.getBool("islogin") == null) {
        mySharedPreference.setBool("islogin", false);
      } else if (mySharedPreference.getBool("islogin")! == true) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => UserHome(_useIDController.text)));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 75),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: const InputDecoration(hintText: "UserID"),
                  controller: _useIDController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: const InputDecoration(hintText: "Password"),
                  controller: _passwordController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    print(_useIDController.text);
                    http
                        .get(Uri.parse(
                            "http://$hostname:8070/getAdmin/${_useIDController.text}"))
                        .then((value) async {
                      final jsonMap = value.body;
                      print(jsonDecode(jsonMap)['dob']);
                      //print(jsonDecode(jsonMap)['status']);
                      if (jsonDecode(jsonMap)['status'] == 500) {
                        print(
                            "User not found in database, invalid userid or password");
                        //     "Invalid password");
                      } else if (jsonDecode(jsonMap)['dob']
                              .toString()
                              .substring(0, 10) !=
                          _passwordController.text) {
                        print("Invalid Password");
                      } else {
                        print("Response: ${value.body}");
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return AdminHome(_useIDController.text);
                        }));

                        await setLoginInSharedPreferenceForAdmin(true);
                        await setLoginInSharedPreferenceForConsumer(true);
                      }
                    }).catchError((e) => print(e));
                  },
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 64.0),
                    child: Text("Login As Admin"),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64.0, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (builder) =>
                              UserHome(_useIDController.text)),
                    );
                  },
                  child: Text("Login as Consumer"),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Registration(widget.adminRegister),
                      ),
                    );
                  },
                  child: Text("Register As Admin"),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64.0, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => Registration(widget.userRegister),
                      ),
                    );
                  },
                  child: Text("Register As Consumer"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
