import 'package:flutter/material.dart';
import 'package:flutter_locator/provider/location_provider.dart';
import 'package:provider/provider.dart';
import 'google_maps_page.dart';

void main() {
  
  runApp(MultiProvider(providers: [
     ChangeNotifierProvider(create: (_) => LocationProvider()),
  ], child: MyApp(),) );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GoogleMapPage(),
    );
  }
}
