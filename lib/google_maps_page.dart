// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_locator/bloc/location_bloc.dart';
import "package:flutter_locator/provider/location_provider.dart";
import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
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

  @override
  void initState() {
    super.initState();
   
  }



  @override
  Widget build(BuildContext context) {


  
    return BlocProvider(
      create: (context) => LocationBloc()..add(GetLocation()),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Locator"),
            centerTitle: true,
            backgroundColor: Colors.redAccent,
          ),
          body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
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
                 return _googlemap( double.parse(state.latitude), double.parse(state.longitude));

              case LocationStatus.loaded:
                if (state.latitude == "") {
                  return const Center(
                    child: Text('Hmm, no Location! That\'s new. 😃'),
                  );
                }



               if(AppFunctions().calculateDistance(double.parse(state.latitude), double.parse(state.longitude), -1.25624, 36.7141433) > 10) {
                 AppFunctions().showNotification("Geofence breached","You are out of the location radius");
               }

                return _googlemap( double.parse(state.latitude), double.parse(state.longitude));
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

  Widget _googlemap( double latitude, double longitude){
    return  Stack(
      children: [


        GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                target: LatLng(
                    latitude,
                    longitude),
                zoom: 15),
            markers: {
              Marker(
                  markerId: const MarkerId("marker1"),

                  position: LatLng(
                     latitude,
                      longitude),
                  draggable: true,
                  onDragEnd: (value) {},
                  icon: BitmapDescriptor.defaultMarker),
            },

            onMapCreated: (GoogleMapController controller) {
              controller = controller;
            },
          ),
        Container(
          color: Colors.white,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(

                height: 70,
                width: MediaQuery.of(context).size.width * 0.35,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),

                    decoration: InputDecoration(
                      hintText: "origin longitude",

                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(color: Colors.black),

                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      fillColor: Colors.black,
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),),

              Container(

                height: 70,
                width: MediaQuery.of(context).size.width * 0.35,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),

                    decoration: InputDecoration(
                      hintText: "origin latitude",

                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(color: Colors.black),

                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      fillColor: Colors.black,
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),),
            ],
          ),
        ),
      ],
    );
  }
}
