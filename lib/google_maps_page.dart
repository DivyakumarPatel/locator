// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locator/bloc/location_bloc.dart';
import "package:flutter_locator/provider/location_provider.dart";
import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:provider/provider.dart";

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
    return  GoogleMap(
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
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          controller = controller;
        },
      );
  }
}
