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
  get create => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
    MultiProvider(providers: [
      create: (_) => LocationProvider(),
      StreamProvider.value(create:(context) => context.read<LocationProvider>().location value: , initialData: null    ],
    child:  Scaffold(
      appBar: AppBar(
          title: Text("LocatorDO"),
          backgroundColor: Colors.redAccent,
        ),
        body: googleMapUI()) ,
    )
    ;
  }

  Widget googleMapUI() {
    return Provider>(builder: (consumerContext, model, child) {
      if (model.locationPosition != null) {
        return Column(children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition:
                  CameraPosition(target: model.locationPosition, zoom: 12),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {},
            ),
          )
        ]);
      }
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
