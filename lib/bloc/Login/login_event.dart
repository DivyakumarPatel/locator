// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginEvent {}

class Signup extends LoginEvent {
  final String password;
  final String email;
  final String middleName;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  const Signup(
      {required this.password,
      required this.email,
      required this.middleName,
      required this.firstName,
      required this.lastName,
      required  this.phoneNumber});
}

class GetLogin extends LoginEvent {
  final String email;

  final String password;

  GetLogin({
    required this.email,
    required this.password,
  });
}
