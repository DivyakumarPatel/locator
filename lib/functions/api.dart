// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'constants.dart';

class Api {
  final dio = Dio();
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    String? firebase_id = await FirebaseMessaging.instance.getToken();
    const url = "$BASEURL/api/login";
    var data = {
      "email": email,
      "password": password,
      "firebase_id": firebase_id.toString(),
    };
    log("login url: $url");

    log(data.toString());

    Response response = await dio.post(
      url,
      data: data,
    );

    log("response is: ${response.data}");
    return response;
  }

  Future<Response> updateLocation({
    required double current_latitude,
    required double current_longitude,
    required double max_distance,
    required double origin_longitude,
    required double origin_latitude,
  }) async {
    String user_id = HydratedBloc.storage.read("id");
    const url = "$BASEURL/api/location";
    var data = {
      "current_latitude": current_latitude.toString(),
      "current_longitude": current_longitude.toString(),
      "max_distance": max_distance.toString(),
      "user_id": user_id.toString(),
      "origin_longitude": origin_longitude.toString(),
      "origin_latitude": origin_latitude.toString()
    };

    log(data.toString());

    Response response = await dio.post(
      url,
      data: data,
    );

    log("response is: ${response.data}");
    return response;
  }

  Future<Response> getDevices() async {
    const url = "$BASEURL/api/location";
    Response response = await dio.get(
      url,
    );

    log("response is: ${response.data}");
    return response;
  }

  Future<Response> signup({
    required String password,
    required String email,
    required String middleName,
    required String firstName,
    required String phoneNumber,
  }) async {
    const url = "$BASEURL/api/register";

    String? firebase_id = await FirebaseMessaging.instance.getToken();
    var data = {
      "email": email,
      "first_name": firstName,
      "middle_name": middleName,
      "phone_number": phoneNumber,
      "firebase_id": firebase_id,
      "password": password
    };



    Response response = await dio.post(
      url,
      data: data,
    );


    return response;
  }
}
