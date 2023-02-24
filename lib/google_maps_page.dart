// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_locator/bloc/location_bloc.dart';
import "package:flutter_locator/provider/location_provider.dart";
import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import "package:provider/provider.dart";

import 'functions/app_functions.dart';
import 'main.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late GoogleMapController controller;
  get create => null;

  Timer? timer;
  late BitmapDescriptor markerbitmap;

  void createOrigincon() async {
    markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/destination-map-marker.png",
    );
  }

  @override
  void initState() {
    super.initState();
    createOrigincon();
  }

  void fetchLocationPeriodically() {}

  @override
  Widget build(BuildContext context) {
    
    late double lat_origin;
    late double long_origin;
    late double geofenceRadius;

    bool notificationsent = false;

    return BlocProvider(
      create: (context) => LocationBloc()..add(GetLocation()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Locator"),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Add origin coodinates"),
                    content: Container(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 40,
                            // width: MediaQuery.of(context).size.width * 0.35,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                decoration: InputDecoration(
                                  hintText: "Geofence Radius (kms)",
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  fillColor: Colors.black,
                                ),
                                onChanged: (value) {
                                  geofenceRadius = double.parse(value);
                                },
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            //width: MediaQuery.of(context).size.width * 0.35,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                decoration: InputDecoration(
                                  hintText: "Origin Longitude",
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  fillColor: Colors.black,
                                ),
                                onChanged: (value) {
                                  long_origin = double.parse(value);
                                },
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            // width: MediaQuery.of(context).size.width * 0.35,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                decoration: InputDecoration(
                                  hintText: "origin latitude",
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  fillColor: Colors.black,
                                ),
                                onChanged: (value) {
                                  lat_origin = double.parse(value);
                                },
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
                      ),
                      MaterialButton(
                          onPressed: () {
                            HydratedBloc.storage
                                .write("lat_origin", lat_origin);
                            HydratedBloc.storage
                                .write("long_origin", long_origin);
                            HydratedBloc.storage
                                .write("geofence_radius", geofenceRadius);
                            Navigator.of(context).pop();
                          },
                          child: Text("Submit"))
                    ],
                  );
                });
          },
          label: Text("Add Origin"),
          icon: Icon(Icons.add),
        ),
        body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
            timer = Timer.periodic(Duration(seconds: 10),
                (Timer t) => context.read<LocationBloc>().add(GetLocation()));
            switch (state.status) {
              case LocationStatus.loading:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case LocationStatus.error:
                if (state.latitude == "") {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
                return _googlemap(double.parse(state.latitude),
                    double.parse(state.longitude));

              case LocationStatus.loaded:
                if (state.latitude == "") {
                  return const Center(
                    child: Text('Hmm, no Location! That\'s new. 😃'),
                  );
                }

                //check if origin has been set, if not, set it as the current location
                if (HydratedBloc.storage.read("lat_origin") == null ||
                    HydratedBloc.storage.read("long_origin") == null ||
                    HydratedBloc.storage.read("geofence_radius") == null) {
                  HydratedBloc.storage.write("geofence_radius", 10);
                  HydratedBloc.storage
                      .write("lat_origin", double.parse(state.latitude));
                  HydratedBloc.storage
                      .write("long_origin", double.parse(state.longitude));
                } else {
                  if ((AppFunctions().calculateDistance(
                              double.parse(state.latitude),
                              double.parse(state.longitude),
                              HydratedBloc.storage.read("lat_origin"),
                              HydratedBloc.storage.read("long_origin")) >
                          HydratedBloc.storage.read("geofence_radius")) &&
                      notificationsent == false) {
                    AppFunctions().showNotification("Geofence breached!",
                        "You are out of the location radius");
                    notificationsent = true;
                  }
                }

                return _googlemap(double.parse(state.latitude),
                    double.parse(state.longitude));
              default:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
            }
          },
        ),
      ),
    );
  }

  Widget _googlemap(double latitude, double longitude) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition:
          CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
      markers: {
        Marker(
            markerId: const MarkerId("marker1"),
            infoWindow: InfoWindow(title: "origin location"),
            position: HydratedBloc.storage.read("lat_origin") != null
                ? LatLng(HydratedBloc.storage.read("lat_origin"),
                    HydratedBloc.storage.read("long_origin"))
                : LatLng(latitude, longitude),
            draggable: true,
            onDragEnd: (value) {},
            icon: BitmapDescriptor.defaultMarker),
        Marker(
            markerId: const MarkerId("marker2"),
            infoWindow:
                InfoWindow(snippet: "My Location", title: "my location"),
            position: LatLng(latitude, longitude),
            draggable: true,
            onDragEnd: (value) {},
            icon: BitmapDescriptor.defaultMarker),
      },
      onMapCreated: (GoogleMapController controller) {
        controller = controller;
      },
    );
  }
}
