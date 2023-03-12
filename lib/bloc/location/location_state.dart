part of 'location_bloc.dart';



class LocationState extends Equatable {

  String latitude;
  String longitude;


  final LocationStatus status;

LocationState({this.latitude = "", this.longitude = "", this.status = LocationStatus.initial});

 
  LocationState copyWith({
    String? latitude,
  String? longitude,
    LocationStatus? status,
  }) {
    return LocationState(
     latitude: latitude ?? this.latitude,
     longitude:  longitude ?? this.longitude,
     status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [latitude, longitude, status];

 
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'articles': latitude,
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
}


enum LocationStatus { initial, loading, loaded, error }
