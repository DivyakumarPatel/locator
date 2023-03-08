// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'constants.dart';

class Api {
  final dio = Dio();

  Future<http.Response> login({

    required String email,
    required String password,
  }) async {
    const url = "$BASEURL/api/v1/auth/users/landlords/signin";
    var data = {"email": email, "password": password};

    log(data.toString());

    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"email": email, "password": password}),
    );
    log(response.body.toString());

    return response;
  }

  Future<http.Response> signup({
    required String password,
    required String email,
    required String middleName,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    const url = "$BASEURL/api/v1/auth/users/landlords/signup";

    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "firstname": firstName,
        "middlename": middleName,
        "lastname": lastName,
        "email": email,
        "phonenumber": phoneNumber,
        "password": password
      }),
    );
    log(response.body.toString());

    return response;
  }

  Future<List> getdata(String Url) async {
    List listOfData = [];
    //
    String loggedInToken = HydratedBloc.storage.read("token");
    final String token = "Token $loggedInToken";
    final String url = "$BASEURL$Url";

    log("$token $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': token,
        },
      );

      var jsonbody = json.decode(response.body);
      listOfData.add(jsonbody);
    } catch (e) {
      log(e.toString());
      rethrow;
    }

    return listOfData;
  }

  Future<List> postdata(
    String Url,
    String rentalname,
    String rentaltype,
    String rentalowner,
    String spacesize,
    String location,
  ) async {
    List listOfData = [];
    //
    String loggedInToken = HydratedBloc.storage.read("token");
    final String token = "Token $loggedInToken";
    final String url = "$BASEURL$Url";

    Map<String, dynamic> payload = {
      "rentalname": "Basdfgraka",
      "rentaltype": "monthly rent",
      "rentalowner": "landlord id",
      "spacesize": 24,
      "location": {
        "locationname": "Ongata Rongai Maasai Lodge",
        "lat": "8454454545.545.45.",
        "lng": "8454454545.545.45."
      }
    };

    String body = json.encode(payload);

    log("$token $url");
    log("changed");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json', 
          'x-access-token': token,
        },
        body: body,
      );

      var jsonbody = json.decode(response.body);

      listOfData.add(jsonbody);
    } catch (e) {
      log(e.toString());
      rethrow;
    }

    return listOfData;
  }
}
