import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
final String  id;
final String firstname;
final String  middlename;
final String  lastname;
//final String  properties;
final String  password;
final String  phonenumber;
final String  email;
  User({
    required this.id,
    required this.firstname,
    required this.middlename,
    required this.lastname,
    //required this.properties,
    required this.password,
    required this.phonenumber,
    required this.email,
  });
   


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      firstname: json['firstname'] as String,
      middlename: json['middlename'] as String,
      lastname: json['lastname'] as String,
      //properties: json['properties'] as String,
      password: json['password'] as String,
      phonenumber: json['phonenumber'] as String,
      email: json['email'] as String,
    );
  }

 
}
