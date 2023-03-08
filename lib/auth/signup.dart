// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locator/google_maps_page.dart';

import '../../bloc/Login/login_bloc.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String password = "";
  String email = "";
  String middleName = "";
  String firstName = "";
  String lastName = "";
  String phoneNumber = "";

  String confirm_password = "";

  final formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: BlocProvider(
          create: (context) => LoginBloc(),
          child: Center(
            child: Form(
              key: formKey,
              child: ListView(children: [
                Padding(padding: EdgeInsets.all(30)),
                Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Padding(padding: EdgeInsets.all(20)),
                //email
                textForm(
                    "Email", TextInputType.emailAddress, Icons.email_outlined),
                textForm(
                    "First Name", TextInputType.text, Icons.person_outline),
                textForm("Last Name", TextInputType.text, Icons.person_outline),
                textForm(
                    "Middle Name", TextInputType.text, Icons.person_outline),
                textForm("Phone Number", TextInputType.number, Icons.phone),

                //password
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: _obscureText == true
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off)),
                    isDense: true,
                    labelText: "Enter Password",
                    labelStyle: TextStyle(color: Colors.grey),
                    icon: Icon(Icons.lock, color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    fillColor: Colors.black,
                  ),
                  style: TextStyle(color: Colors.black),
                  validator: (val) =>
                      val!.length < 6 ? "Pasword too short" : null,
                  onChanged: (value) {
                    password = value;
                  },
                  onSaved: (val) => password = val!,
                  obscureText: _obscureText,
                ),
                Padding(padding: EdgeInsets.all(10)),
                //confirm password
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: _obscureText == true
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off)),
                    isDense: true,
                    labelText: "Confirm Password",
                    labelStyle: TextStyle(color: Colors.grey),
                    icon: Icon(Icons.lock, color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    fillColor: Colors.black,
                  ),
                  style: TextStyle(color: Colors.black),
                  validator: (val) =>
                      val! != password ? "Passwords do not match" : null,
                  onChanged: (value) {
                    confirm_password = value;
                  },
                  onSaved: (val) => confirm_password = val!,
                  obscureText: _obscureText,
                ),
                Padding(padding: EdgeInsets.all(20)),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state.status == LoginStatus.success) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => GoogleMapPage()));
                    }

                    if (state.status == LoginStatus.failed) {
                      final snackBar = SnackBar(
                        content: Text(state.message),
                        backgroundColor: (Colors.red),
                        action: SnackBarAction(
                          label: '',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                    if (state.status == LoginStatus.error) {
                      final snackBar = SnackBar(
                        content: Text(
                            "Signup failed! Check your interrnet and try again"),
                        backgroundColor: (Colors.red),
                        action: SnackBarAction(
                          label: '',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  builder: (context, state) {
                    return BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state.status == LoginStatus.loading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ElevatedButton(
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              } else {
                                context.read<LoginBloc>().add(Signup(
                                    password: password,
                                    email: email,
                                    middleName: middleName,
                                    firstName: firstName,
                                    lastName: lastName,
                                    phoneNumber: phoneNumber));
                              }
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: 200,
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(fontSize: 18),
                                )));
                      },
                    );
                  },
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget textForm(
      String label_text, TextInputType keyboard_type, IconData icon) {
    return Column(
      children: [
        TextFormField(
          keyboardType: keyboard_type,
          decoration: InputDecoration(
            labelText: label_text,
            isDense: true,
            labelStyle: TextStyle(color: Colors.grey),
            icon: Icon(icon, color: Colors.black),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            fillColor: Colors.black,
          ),
          style: TextStyle(color: Colors.black),
          validator: (val) {
            String? returnValue;
            if (label_text.contains("Email")) {
              returnValue = !val!.contains("@") ? "Enter a valid Email" : null;
            } else if (label_text.contains("First Name")) {
              returnValue = val!.length < 2 ? "Enter a valid name" : null;
            } else if (label_text.contains("Last Name")) {
              returnValue = val!.length < 2 ? "Enter a valid name" : null;
            } else if (label_text.contains("Phone Number")) {
              returnValue =
                  val!.length != 10 ? "Enter a valid Phone Number" : null;
            }

            return returnValue;
          },
          onChanged: (value) {
            if (label_text.contains("Email")) {
              email = value;
            } else if (label_text.contains("First Name")) {
              firstName = value;
            } else if (label_text.contains("Middle Name")) {
              middleName = value;
            } else if (label_text.contains("Last Name")) {
              lastName = value;
            } else if (label_text.contains("Phone Number")) {
              phoneNumber = value;
            }
          },
          onSaved: (val) => email = val!,
        ),
        Padding(padding: EdgeInsets.all(10)),
      ],
    );
  }
}
