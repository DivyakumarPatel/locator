// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'location_bloc.dart';

class LocationState extends Equatable {
  String latitude;
  String longitude;
  List devices;

  final LocationStatus status;

  LocationState( 
      {this.latitude = "",
      this.longitude = "",
      this.devices = const [],
      this.status = LocationStatus.initial});

  @override
  List<Object> get props => [latitude, longitude, status];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'status': status.index,
    };
  }

  factory LocationState.fromMap(Map<String, dynamic> map) {
    int index = map['status'];

    return LocationState(
      status: LocationStatus.values[index],
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationState.fromJson(String source) =>
      LocationState.fromMap(json.decode(source) as Map<String, dynamic>);

  LocationState copyWith({
    String? latitude,
    String? longitude,
    List? devices,
    LocationStatus? status,
  }) {
    return LocationState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      devices: devices ?? this.devices,
     status: status ?? this.status,
    );
  }
}

enum LocationStatus {
  initial,
  loading,
  loaded,
  error,
  loadingDevices,
  getDevicesError,
  getDevicesSuccess
}
