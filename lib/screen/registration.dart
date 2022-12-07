import 'dart:convert';

import 'dart:io';
import 'package:phone_number/phone_number.dart' as pn;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_and_mysql_server/utils/constants.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Registration extends StatefulWidget {
  Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool showSpinner = false;
  DateTime dateTime = DateTime.now();
  bool isVerified = false;
  bool isMobileVerifeid = false;
  late Timer _timer;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _peronalIDController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobilePhoneController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String globalVerificationId = "";
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();

  Future<File?> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      debugPrint("Choosed file is: ${result!.files[0].path}");
      if (result != null) {
        File tempImage = File(result.files.single.path!);
        // String imageURL = "Loading";
        // final request = http.MultipartRequest(
        //     "POST", Uri.parse("http://$hostname:8080/addProfilePhoto"));
        // debugPrint("Adding File");
        // request.files.add(
        //   await http.MultipartFile.fromPath(
        //     "profilePhoto",
        //     tempImage.path,
        //     filename: tempImage.uri.pathSegments.last,
        //   ),
        //)
        // final streamedResponse = request.send();
        // streamedResponse.then((value) {
        //   print(value);
        // }).catchError(print);
        return tempImage;
      }
    } catch (e) {
      print("Image " + e.toString());
    }
  }

  void sendVerifactionLink() {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (!currentUser!.emailVerified) {
      currentUser.sendEmailVerification().then((value) => {
            print("Linked Send"),
          });
    } else {
      print("Mail Id Not varified");
    }
  }

  registerAccount() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: "${dateTime.day}/${dateTime.month}/${dateTime.year}")
        .then((value) {
      sendVerifactionLink();
    }).catchError((e) {
      if (e is FirebaseAuthException) {
        if (e.code == "email-already-in-use") {
          print("email is alredy in use");
        }
      }
    });

    print("Register Function");
  }

  @override
  void initState() {
    FirebaseAuth.instance.signOut();
    print("Init");
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      isVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

      print("checking for isVerified email $isVerified");
      if (isVerified) {
        setState(() {
          _timer.cancel();
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(title: const Text("Registration Page")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    decoration: const InputDecoration(hintText: "Name"),
                    controller: _nameController),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    decoration: const InputDecoration(hintText: "Surname"),
                    controller: _surnameController),
              ),
              GestureDetector(
                  onTap: () => {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        ).then((selectedDateTime) {
                          print(selectedDateTime);
                          setState(() {
                            if (selectedDateTime != null) {
                              dateTime = selectedDateTime;
                            }
                          });
                        })
                      },
                  child: Row(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.calendar_month,
                        size: 30,
                      ),
                    ),
                    Container(
                      color: Colors.grey.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Text(
                          "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                        ),
                      ),
                    ),
                  ])),
              const Divider(
                indent: 8,
                endIndent: 8,
                color: Color.fromARGB(129, 158, 158, 158),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(hintText: "PersonalID"),
                  controller: _peronalIDController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(hintText: "Address"),
                  controller: _addressController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(hintText: "Email"),
                        controller: _emailController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: isVerified
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : ElevatedButton(
                              onPressed: () {
                                print("Verify button clicked");
                                registerAccount();
                              },
                              child: const Text("Verify")),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration:
                            const InputDecoration(hintText: "Mobile Phone"),
                        controller: _mobilePhoneController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isMobileVerifeid
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                print("Hello");
                                            print("Mobile Verify Button Pressed");
                                            String formattedPhoneNumber = await pn.PhoneNumberUtil().format(
                                    "+91 ${_mobilePhoneController.text.replaceAll(' ', '')}",
                                    "IN");
                                print("Formatted Phone Number  $formattedPhoneNumber");

                                await auth
                                    .verifyPhoneNumber(
                                  phoneNumber: formattedPhoneNumber,
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) async {
                                    print("Credentials");
                                    print(credential);
                                    await auth
                                        .signInWithCredential(credential)
                                        .then((UserCredential userCredential) {
                                      print("User Logged In successfully");
                                      print(userCredential.user!.phoneNumber);
                                    }).catchError((error) {
                                      print(error);
                                    });
                                  },
                                  verificationFailed: (FirebaseAuthException e) {
                                    print("firebase auth error");
                                    print(e);
                                  },
                                  codeSent:
                                      (String verificationId, int? resendToken) async {
                                    print("verification id = $verificationId");
                                    print("resend token = $resendToken");

                                    globalVerificationId = verificationId;
                                  },
                                  codeAutoRetrievalTimeout: (String verificationId) {
                                    print("code auto retrieval timeout verification id");
                                    print(verificationId);
                                  },
                                )
                                    .catchError((e) {
                                  print(e);
                                  showDialog(
                                      context: context, builder: (context) => Text(e));
                                });
                              },
                              child: const Text("Verify")),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      File? pickedImageFile = await pickImage();
                      if (pickedImageFile != null) {
                        final aadharImageRef =
                            storageRef.child("AadharImage.jpg");
                        print(
                            "Uploaded Image Download URL: ${aadharImageRef.getDownloadURL()}");
                        try {
                          await aadharImageRef
                              .putFile(pickedImageFile)
                              .then((value) => showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialog(
                                        content:
                                            Text("Image Uploaded Successfully"),
                                      )));
                        } catch (e) {
                          //
                        }
                      }
                    },
                    child: const Text("Upload ID Proof"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      File? pickedImageFile = await pickImage();
                      if (pickedImageFile != null) {
                        final profileImageRef =
                            storageRef.child("ProfileImage.jpg");
                        print(
                            "Uploaded Image Download URL: ${profileImageRef.getDownloadURL()}");
                        try {
                          await profileImageRef
                              .putFile(pickedImageFile)
                              .then((value) => showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialog(
                                        content:
                                            Text("Image Uploaded Successfully"),
                                      )));
                        } catch (e) {
                          //
                        }
                      }
                    },
                    child: const Text("Upload Profile Photo"),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 10),
                child: ElevatedButton(
                    onPressed: isVerified == false
                        ? null
                        : () async {
                            print("77777777777777777777777");

                            await http
                                .post(
                                  Uri.parse("http://$hostname:8080/addAdmin"),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(<String, String>{
                                    "name": _nameController.text,
                                    "surname": _surnameController.text,
                                    "dob": dateTime.toString().substring(0, 10),
                                    "personalID": _peronalIDController.text,
                                    "address": _addressController.text,
                                    "email": _emailController.text,
                                    "mobileNumber": _mobilePhoneController.text,
                                  }),
                                )
                                .then((value) => print(value.body))
                                .catchError((e) => print(e));
                            setState(() {
                              Fluttertoast.showToast(
                                  msg: 'Registered sucessfully',
                                  backgroundColor: Colors.red);

                              _nameController.text = "";
                              _surnameController.text = "";
                              _emailController.text = "";
                              _mobilePhoneController.text = "";
                              _addressController.text = "";
                              _peronalIDController.text = "";
                            });
                          }, //Code here when button is pressed
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      child: Text(
                        "Registration as Consumer",
                      ),
                    )),
              ),

              // Padding(
              //   padding: const EdgeInsets.only(top: 20, bottom: 10),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color.fromARGB(255, 242, 4, 4),
              //     ),

              //     onPressed: isVerified == false
              //         ? null
              //         : () async {
              //             print("77777777777777777777777");
              //             await http
              //                 .post(
              //                   Uri.parse("http://localhost:8080/addConsumer"),
              //                   headers: <String, String>{
              //                     'Content-Type': 'application/json; charset=UTF-8',
              //                   },
              //                   body: jsonEncode(<String, String>{
              //                     "name": _nameController.text,
              //                     "surname": _surnameController.text,
              //                     "dob": dateTime.toString().substring(0, 10),
              //                     "personalID": _peronalIDController.text,
              //                     "address": _addressController.text,
              //                     "email": _emailController.text,
              //                     "mobileNumber": _mobilePhoneController.text,
              //                   }),
              //                 )
              //                 .then((value) => print(value.body))
              //                 .catchError((e) => print(e));
              //             setState(() {
              //               Fluttertoast.showToast(
              //                   msg: 'Registered sucessfully',
              //                   backgroundColor: Colors.red);

              //               _nameController.text = "";
              //               _surnameController.text = "";
              //               _emailController.text = "";
              //               _mobilePhoneController.text = "";
              //               _addressController.text = "";
              //               _peronalIDController.text = "";
              //             });
              //           }, //Code here when button is pressed
              //     //Code here when button is pressed
              //     child: const Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              //       child: Text(
              //         "Registration as Consumer",
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
