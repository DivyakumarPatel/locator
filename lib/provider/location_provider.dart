// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  // late BitmapDescriptor _pinLocationIcon;
  // BitmapDescriptor get pinLocationIcon => _pinLocationIcon;
  // late Map<MarkerId, Marker> _markers;
  // Map<MarkerId, Marker> get markers => _markers;

  // final MarkerId markerId = MarkerId("1");

  late Location _location;
  Location get location => _location;
  late LatLng _locationPosition = LatLng(42.267450, -83.038012);
  LatLng get locationPosition => _locationPosition;

  bool locationServiceActive = true;

  LocationProvider() {
    _location = new Location();
  }

  initialization() async {
    await getUserLocation();
  }

  getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      _locationPosition =
          LatLng(currentLocation.latitude!, currentLocation.latitude!);

      log(_locationPosition.latitude.toString());
      log(_locationPosition.longitude.toString());

      notifyListeners();
    });
  }
}
