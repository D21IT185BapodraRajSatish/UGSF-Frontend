import 'dart:convert';

class UserModel {
  int id;
  String name;
  String surname;
  String personalID;
  String address;
  String email;
  String mobileNumber;
  String capitalAccountID;
  String spendableAccountID;
  String dob;
  double capitalAccountBalance;
  double spendableAccountBalance;
  String aadharImageURL;
  String profileImageURL;
  bool isValidated;

  // Consumer(this.id,this.name,this.surname,this.personalID,this.address,this.email,this.mobilePhone,this.capitalAccount,this.spendableAccount)
  UserModel.fromJson(dynamic json)
      : id = json['id'],
        name = json['name'],
        surname = json['surname'],
        personalID = json['personalID'],
        address = json['address'],
        email = json['email'],
        dob = json['dob'],
        mobileNumber = json['mobileNumber'],
        capitalAccountID = json['capitalAccountID'],
        spendableAccountID = json['spendableAccountID'],
        aadharImageURL =json['aadharImageURL'],
        capitalAccountBalance=json['capitalAccountBalance'],
        profileImageURL = json['profileImageURL'],
        spendableAccountBalance = json['spendableAccountBalance'],
        isValidated = json['validated'];
}
