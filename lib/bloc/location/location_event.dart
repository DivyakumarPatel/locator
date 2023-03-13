// ignore_for_file: non_constant_identifier_names

part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}



class GetLocation extends LocationEvent {}

class UpdateLocation extends LocationEvent{
  final  double current_latitude;
  final double current_longitude;
  final double max_distance;
  final double origin_longitude;
  final double origin_latitude;

  const UpdateLocation({required this.current_latitude, required this.current_longitude,
    required this.max_distance, required this.origin_longitude, required this.origin_latitude});
}


