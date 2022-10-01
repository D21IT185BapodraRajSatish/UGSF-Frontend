// 🚩 Dada Ki Jay Ho 🚩

// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: View( ));
  }
}

class View extends StatefulWidget {
  const View({super.key});

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  
  
  late Consumer consumer;
  TextEditingController _idController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _personalIDController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobilePhoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Minomics"),
      ),
      // backgroundColor: Colors.red,
      body: SafeArea(
          child: Column(
        children: [
          
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "Name"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: _surnameController,
              decoration: InputDecoration(hintText:"Surname"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: _personalIDController,
              decoration: InputDecoration(hintText:"PersonalID"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: _addressController,
              decoration: InputDecoration(hintText:"Address"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(hintText:"Email"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: _mobilePhoneController,
              decoration: InputDecoration(hintText:"Mobile"),
            ),
          ),
          
          ElevatedButton(
              onPressed: () async {
                consumer = Consumer(
                    _nameController.text,
                    _surnameController.text,
                    _personalIDController.text,
                    _addressController.text,
                    _emailController.text,
                    _mobilePhoneController.text);
                print("Reached here");
                http
                    .post(
                      Uri.parse("http://10.55.51.99:8080/add"),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, String>{
                        
                        "name": _nameController.text,
                        "surname": _surnameController.text,
                        "personalID":_personalIDController.text,
                        "address":_addressController.text,
                        "email":_emailController.text,
                        "mobileNumber":_mobilePhoneController.text

                      }),
                    )
                    .then((value) => print(value.body))
                    .catchError((e) => print(e));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 64),
                child: Text("Submit"),
              ))
        ],
      )),
    );
  }
}

class Consumer {
  String? _name;
  String? _surname;
  String? _personalId;
  String? _address;
  String? _email;
  String? _mobilePhone;

  Consumer(
    String _name,
    String _surname,
    String _personalId,
    String _address,
    String _email,
    String _mobilePhone,
  ) {
    this._name = _name;
    this._surname = _surname;
    this._personalId = _personalId;
    this._address = _address;
    this._email = _email;
    this._mobilePhone = _mobilePhone;
  }

  get name => _name;

  set name(value) => _name = value;

  get surname => _surname;

  set surname(value) => this._surname = value;

  get personalId => this._personalId;

  set personalId(value) => this._personalId = value;

  get address => this._address;

  set address(value) => this._address = value;

  get email => this._email;

  set email(value) => this._email = value;

  get mobileNumber => this._mobilePhone;

  set mobileNumber(value) => this._mobilePhone = value;
}
