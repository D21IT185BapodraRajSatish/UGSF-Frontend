import 'dart:convert';

class UserModel {
  int id;
  String name;
  String surname;
  String personalID;
  String address;
  String email;
  String mobilePhone;
  String capitalAccount;
  String spendableAccount;
  String? dob;
  bool isValidated;

  // Consumer(this.id,this.name,this.surname,this.personalID,this.address,this.email,this.mobilePhone,this.capitalAccount,this.spendableAccount)
  UserModel.fromJson(dynamic json)
      : id = json['id'],
        name = json['name'],
        surname = json['surname'],
        personalID = json['personalID'],
        address = json['address'],
        email = json['email'],
        mobilePhone = json['mobileNumber'],
        capitalAccount = json['capitalAccountID'],
        spendableAccount = json['spendableAccountID'],
        isValidated = json['validated'];
}
