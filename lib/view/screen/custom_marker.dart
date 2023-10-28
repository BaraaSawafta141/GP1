import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class customMarker extends StatefulWidget {
  const customMarker({super.key});

  @override
  State<customMarker> createState() => customMarkerState();
}

class customMarkerState extends State<customMarker> {
  final Completer<GoogleMapController> _controller = Completer();

  List<String> images = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
    'assets/images/4.png',
    'assets/images/5.png',
    'assets/images/6.png',
  ];

  final List<Marker> _markers = <Marker>[];
  final List<LatLng> _latlng = <LatLng>[
    LatLng(32.223295060141346, 35.237885713381246),
    LatLng(32.22376702872116, 35.239902734459896),
    LatLng(32.22108040562581, 35.23814320546564),
    LatLng(32.22535466270865, 35.24139978035635),
    LatLng(32.22370325652111, 35.24003458793593),
    LatLng(32.22074576133657, 35.2327620677686),
  ];

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(32.223295060141346, 35.237885713381246),
    zoom: 14.5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      )),
    );
  }
}
