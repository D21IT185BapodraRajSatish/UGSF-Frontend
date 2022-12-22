import 'dart:convert';

import 'dart:io';
import 'package:flutter_and_mysql_server/functions.dart';
import 'package:phone_number/phone_number.dart' as pn;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_and_mysql_server/utils/constants.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Registration extends StatefulWidget {
  String? currentRequest;
  Registration(this.currentRequest);
  String setLabel = "";
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String generatedOtp = "";
  bool showSpinner = false;
  DateTime dateTime = DateTime.now();
  bool isVerified = false;
  bool isMobileVerifeid = false;
  String profileImageURL = "";
  String aadharImageURL = "";
  File idProof = File("");
  String idProofLink = "";
  String idProofLink2 = "";
  late Timer _timer;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _peronalIDController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobilePhoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
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
        //     "POST", Uri.parse("http://$hostname:8070/addProfilePhoto"));
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
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: "${dateTime.day}/${dateTime.month}/${dateTime.year}");
    if (!currentUser!.emailVerified) {
      currentUser.sendEmailVerification().then((value) => {
            print("Linked Send"),
          });
    } else {
      print("Mail Id Not varified");
    }
  }

  void generateRamdomNumber() {
    var rnd = math.Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    print(next.toInt().toString());
    generatedOtp = next.toInt().toString();
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
    generateRamdomNumber();
    print("Init");
    generateRamdomNumber();
    generateRamdomNumber();
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
    widget.setLabel = (widget.currentRequest?.compareTo("addAdmin") == 0)
        ? "Register As Admin"
        : "Register As Consumer";

    print(widget.currentRequest);

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
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("DOB"),
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
                ],
              ),
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
                                String url =
                                    "https://login.smsforyou.biz/V2/http-api.php?apikey=VDJ1muqjMtm6puO4&senderid=CHRUST&number=${_mobilePhoneController.text}&message=Hello,%20$generatedOtp%20is%20your%20One%20Time%20Password(OTP)%20for%20Login%20Access.%20This%20OTP%20is%20valid%20till%2060%20sec%20-%20CHARUSAT&format=json&pe_id=1401712950000018527";
                                http.get(Uri.parse(url)).then((value) {
                                  print("Sucessfully send");
                                }).onError((error, stackTrace) {
                                  print(error);
                                });
                              },
                              child: const Text("Send OTP")),
                    ),
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
                            const InputDecoration(hintText: "Enter OTP"),
                        controller: _otpController,
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
                              onPressed: () {
                                if (_otpController.text == generatedOtp) {
                                  print("Mobile Number Verified");
                                  setState(() {
                                    isMobileVerifeid = true;
                                  });

                                  print(isMobileVerifeid);
                                  print(isVerified);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Invalid OTP',
                                      backgroundColor: Colors.red);
                                }
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
                    // onPressed: () async {
                    //   File? pickedImageFile = await pickImage();
                    //   if (pickedImageFile != null) {
                    //     final aadharImageRef = storageRef.child(
                    //         _mobilePhoneController.text + "AadharImage.jpg");
                    //     print(
                    //         "Uploaded Image Download URL: ${aadharImageRef.getDownloadURL()}");
                    //     aadharImageURL = await aadharImageRef.getDownloadURL();
                    //     try {
                    //       await aadharImageRef
                    //           .putFile(pickedImageFile)
                    //           .then((value) => showDialog(
                    //               context: context,
                    //               builder: (context) => const AlertDialog(
                    //                     content:
                    //                         Text("Image Uploaded Successfully"),
                    //                   )));
                    //     } catch (e) {
                    //       //
                    //     }
                    //   }
                    // },
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  List<File> idProofList =
                                      await chooseListOfFiles();
                                  if (idProofList.isEmpty) return;
                                  idProof = idProofList[0];
                                  print(
                                      "IdProof selected: ${idProof.lengthSync()}");
                                  Navigator.of(context).pop();
                                },
                                child: const CircleAvatar(
                                  radius: 36,
                                  backgroundColor: Colors.purpleAccent,
                                  child: Icon(Icons.collections, size: 36),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const Text("Comming Soon"),
                                  );
                                },
                                child: const CircleAvatar(
                                  radius: 36,
                                  backgroundColor: Colors.purpleAccent,
                                  child: Icon(Icons.camera, size: 36),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                      if (idProof.path != "") {
                        showDialog(
                          context: context,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        Uri uri = Uri.parse(
                            "http://172.16.11.84:4040/api/userlist/uploadIdProof");

                        final request = http.MultipartRequest(
                          "POST",
                          uri,
                        );
                        request.files.add(
                          await http.MultipartFile.fromPath(
                            "media",
                            idProof.path,
                            filename: idProof.uri.pathSegments.last,
                          ),
                        );
                        final streamedResponse = await request
                            .send()
                            .timeout(const Duration(minutes: 2))
                            .catchError(
                          (e) {
                            Navigator.of(context).pop();
                            print(e);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text(e.toString()),
                              ),
                            );
                          },
                        );

                        Navigator.of(context).pop();
                        String jsonMapString =
                            await streamedResponse.stream.bytesToString();
                        idProofLink = jsonDecode(jsonMapString)['data'];
                        print("idProofLink: $idProofLink");
                        setState(() {});
                      } else {
                        print("Id Proof is not selected");
                      }
                    },
                    child: const Text("Upload ID Proof"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  List<File> idProofList =
                                      await chooseListOfFiles();
                                  if (idProofList.isEmpty) return;
                                  idProof = idProofList[0];
                                  print(
                                      "IdProof selected: ${idProof.lengthSync()}");
                                  Navigator.of(context).pop();
                                },
                                child: const CircleAvatar(
                                  radius: 36,
                                  backgroundColor: Colors.purpleAccent,
                                  child: Icon(Icons.collections, size: 36),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const Text("Comming Soon"),
                                  );
                                },
                                child: const CircleAvatar(
                                  radius: 36,
                                  backgroundColor: Colors.purpleAccent,
                                  child: Icon(Icons.camera, size: 36),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                      if (idProof.path != "") {
                        showDialog(
                          context: context,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        Uri uri = Uri.parse(
                            "http://172.16.11.84:4040/api/userlist/uploadIdProof");

                        final request = http.MultipartRequest(
                          "POST",
                          uri,
                        );
                        request.files.add(
                          await http.MultipartFile.fromPath(
                            "media",
                            idProof.path,
                            filename: idProof.uri.pathSegments.last,
                          ),
                        );
                        final streamedResponse = await request
                            .send()
                            .timeout(const Duration(minutes: 2))
                            .catchError(
                          (e) {
                            Navigator.of(context).pop();
                            print(e);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text(e.toString()),
                              ),
                            );
                          },
                        );

                        Navigator.of(context).pop();
                        String jsonMapString =
                            await streamedResponse.stream.bytesToString();
                        idProofLink2 = jsonDecode(jsonMapString)['data'];
                        print("idProofLink: $idProofLink2");
                        setState(() {});
                      } else {
                        print("Id Proof is not selected");
                      }
                    },
                    child: const Text("Upload Profile Photo"),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 10),
                child: ElevatedButton(
                    onPressed: () async {
                            print("77777777777777777777777");
                            print(
                                "http://$hostname:8070/${widget.currentRequest}");
                            await http
                                .post(
                                  Uri.parse(
                                      "http://$hostname:8070/${widget.currentRequest}"),
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
                                    "aadharImageURL": idProofLink,
                                    "profileImageURL": idProofLink2
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

                              print(dateTime.toString().substring(0, 10));
                            });
                          }, //Code here when button is pressed
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      child: Text(
                        widget.setLabel,
                      ),
                    )),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
