// 🚩 Dada Ki Jay Ho 🚩

// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_and_mysql_server/screen/UserHome.dart';
import 'package:flutter_and_mysql_server/screen/adminhome.dart';
import 'package:flutter_and_mysql_server/screen/login.dart';
// import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    // options: DefaultFirebaseOptions.curre,
    
  );
 
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  runApp(MaterialApp(
      
      debugShowCheckedModeBanner: false,
      
      home:
          (_prefs.getBool("isLoginAdmin") ?? false) ? AdminHome("") : _prefs.getBool("isLoginForConsumer")?? false ? UserHome(""):LoginScreen()));
}
