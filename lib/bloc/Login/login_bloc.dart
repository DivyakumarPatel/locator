import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../functions/api.dart';
import '../../models/user/user.dart';


part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends HydratedBloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<GetLogin>(_onGetLogin);
    on<LoginInitial>(_onGetLoginStatus);
    on<Signup>(onSignup);
  }
  void _onGetLoginStatus(LoginInitial event, Emitter<LoginState> emit) {
    emit(state.copyWith(status: LoginStatus.initial));
  }

  void _onGetLogin(GetLogin event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      Response loginDetails = await Api().login(
        email: event.email,
        password: event.password,
      );
      log(loginDetails.data.toString());
      var jsonBody = loginDetails.data;
      log(loginDetails.statusCode.toString());
     

      if (loginDetails.statusCode !=200) {
        emit(state.copyWith(
            status: LoginStatus.failed, message: jsonBody["message"]));
      } else {

        User user = User .fromJson(jsonBody['user']);

        //HydratedBloc.storage.write("token", token);
        HydratedBloc.storage.write("firstname", user.firstName);
        HydratedBloc.storage.write("email", user.email);
        HydratedBloc.storage.write("id", user.id);
        HydratedBloc.storage.write("middlename", user.middleName);
        HydratedBloc.storage.write("phonenumber", user.phoneNumber);
        HydratedBloc.storage.write("status", true);

        emit(state.copyWith(
            status: LoginStatus.success,
            message: jsonBody["message"],
            loggedIn: true));
      }
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: LoginStatus.error, message: e.toString()));
    }
  }

  void onSignup(Signup event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      Response loginDetails = await Api().signup(
          password: event.password,
          email: event.email,
          middleName: event.middleName,
          firstName: event.firstName,
          lastName: event.lastName,
          phoneNumber: event.phoneNumber);
      var jsonBody = loginDetails.data;
      log(loginDetails.statusCode.toString());
      log(jsonBody.toString());

      if (jsonBody["login"] != true) {
        emit(state.copyWith(
            status: LoginStatus.failed, message: jsonBody["message"]));
      } else {
        String token = jsonBody['data']["token"];
        log(token);
        User user = User.fromJson(jsonBody['user']);

        HydratedBloc.storage.write("firstname", user.firstName);
        HydratedBloc.storage.write("email", user.email);
       // HydratedBloc.storage.write("id", user.id);
        HydratedBloc.storage.write("middlename", user.middleName);
        HydratedBloc.storage.write("phonenumber", user.phoneNumber);

        emit(state.copyWith(
            status: LoginStatus.success,
            message: jsonBody["message"],
            loggedIn: true));
      }
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: LoginStatus.error, message: e.toString()));
    }
  }

  @override
  LoginState fromJson(Map<String, dynamic> data) {
    return LoginState.fromJson(json.encode(data));
  }

  @override
  Map<String, dynamic>? toJson(LoginState state) {
    if (state.status == LoginStatus.loaded ||
        state.status == LoginStatus.success) {
      return state.toMap();
    }
    return null;
  }

  @override
  void onChange(Change<LoginState> change) {
    super.onChange(change);
    debugPrint('$change');
  }
}
