// ignore_for_file: prefer_const_constructors

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
    context.read<LocationProvider>().getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Locator"),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(children: [
        Expanded(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                target: LatLng(
                    context.read<LocationProvider>().locationPosition.latitude,
                    context
                        .read<LocationProvider>()
                        .locationPosition
                        .longitude),
                zoom: 18),
            markers: {
              Marker(
                  markerId: const MarkerId("marker1"),
                  position: LatLng(
                      context
                          .read<LocationProvider>()
                          .locationPosition
                          .latitude,
                      context
                          .read<LocationProvider>()
                          .locationPosition
                          .longitude),
                  draggable: true,
                  onDragEnd: (value) {},
                  icon: BitmapDescriptor.defaultMarker),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              controller = controller;
            },
          ),
        )
      ]),
    );
  }
}
