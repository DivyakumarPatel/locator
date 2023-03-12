// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:flutter_locator/Profile/AccountDetails.dart';
import 'package:flutter_locator/auth/Login.dart';
import 'package:flutter_locator/functions/constants.dart';

class Profile extends StatefulWidget {
  final Timer? timer;
  const Profile({
    Key? key,
    required this.timer,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String password = "";

  String firstname = HydratedBloc.storage.read("firstname");
  String email = HydratedBloc.storage.read("email");
  String id = HydratedBloc.storage.read("id");
  String middleName = HydratedBloc.storage.read("middlename");
  String phonenumber = HydratedBloc.storage.read("phonenumber");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade500,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "$firstname $middleName",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(email),
            SizedBox(
              height: 20,
            ),
            Divider(),
            Text(
              "ACCOUNT INFORMATION",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            AccountDetails(
              title: "Email Address",
              subtitle: email,
            ),
            AccountDetails(title: "Name", subtitle: "$firstname $middleName"),
            AccountDetails(title: "Phone Number", subtitle: phonenumber),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(Icons.settings_power),
              title: Text("Log Out"),
              onTap: () {
                AppConstants().alertDialog(
                    context: context,
                    content: Text("Do you want to log out?"),
                    title: "Log out",
                    onpress: () async {

                      if(widget.timer!= null) {
                            widget.timer!.cancel();
                      }
                      
                      HydratedBloc.storage.clear();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Login()),
                          (Route<dynamic> route) => false);
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
