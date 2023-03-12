import 'dart:convert';

import 'package:flutter/material.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
class Devices {
  final double current_latitude;
  final double current_longitude;
  final String user_id;
  final double origin_latitude;
  final double origin_longitude;
  final double max_distance;
  final String email;
  final String first_name;
  final String middle_name;
  final String phone_number;
  final String time;
  Devices({
    required this.current_latitude,
    required this.current_longitude,
    required this.user_id,
    required this.origin_latitude,
    required this.origin_longitude,
    required this.max_distance,
    required this.email,
    required this.first_name,
    required this.middle_name,
    required this.phone_number,
    required this.time,
  });
 

  factory Devices.fromJson(Map<String, dynamic> map) {
    return Devices(
      current_latitude: double.parse(map['current_latitude'].toString()),
      current_longitude:  double.parse(map['current_longitude'].toString()),
      user_id: map['user_id'] .toString(),
      origin_latitude: double.parse(map['origin_latitude'].toString()),
      origin_longitude: double.parse(map['origin_longitude'].toString()),
      max_distance: double.parse(map['max_distance'].toString()),
      email: map['email'].toString(),
      first_name: map['first_name'] .toString(),
      middle_name: map['middle_name'] .toString(),
      phone_number: map['phone_number'] .toString(),
      time: map['time'] .toString(),
    );
  }

  
}
