// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
      final String? id;
      final String? email; 
      final String? firstName; 
      final String? middleName; 
      final String? phoneNumber;

  User({
    this.id,
    this.email,
    this.firstName,
    this.middleName,
    this.phoneNumber,
  });

  

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] = map['id'] .toString() ,
      email: map['email'] = map['email'] .toString() ,
      firstName: map['firstName'] = map['firstName'] .toString() ,
      middleName: map['middleName'] = map['middleName'] .toString() ,
      phoneNumber: map['phoneNumber'] = map['phoneNumber'] .toString() ,
    );
  }

 
}
