// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'devices_bloc.dart';

abstract class DevicesEvent extends Equatable {
  const DevicesEvent();

  @override
  List<Object> get props => [];
}

class DevicesInitial extends DevicesEvent {}

class Signup extends DevicesEvent {
  final String password;
  final String email;
  final String middleName;
  final String firstName;

  final String phoneNumber;

  const Signup(
      {required this.password,
      required this.email,
      required this.middleName,
      required this.firstName,

      required  this.phoneNumber});
}

class GetDevices extends DevicesEvent{

}

