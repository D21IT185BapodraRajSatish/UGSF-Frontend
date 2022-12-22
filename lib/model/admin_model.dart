import 'dart:convert';

class AdminModel {
  int id;
  String name;
  String surname;
  String dob;
  String personalID;
  String address;
  String email;
  String mobileNumber;
  // String? aadharImageURL;
  // String profileImageURL;

  AdminModel.fromJson(dynamic json)
      : id = json['id'],
        name = json['name'],
        surname = json['surname'],
        dob = json['dob'],
        personalID = json['personalID'],
        address = json['address'],
        email = json['email'],
        mobileNumber = json['mobileNumber'];
        // aadharImageURL = json['aadharImageURL'],
        // profileImageURL = json['profileImageURL'];
}
