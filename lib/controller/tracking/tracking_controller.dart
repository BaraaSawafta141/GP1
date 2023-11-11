import 'dart:async';

import 'package:ecommercebig/view/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double? myposLastlati;
double? myposLastlong;

class TrackingController extends GetxController {
  StreamSubscription<Position>? positionStream;
  RxSet<Marker> _marks = <Marker>{}.obs;
  // Create a getter for 'marks'
  RxSet<Marker> get marks => _marks;

  getCurrentLocation() {
    positionStream =
        Geolocator.getPositionStream().listen((Position? position) {
      print(
          'current position:=>> ${position?.latitude.toString()}, ${position?.longitude.toString()}');
      if (mymapcontroller != null) {
        mymapcontroller
            ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(position!.latitude, position.longitude),
          zoom: 15,
        )));
        marks.removeWhere(
            (element) => element.markerId.value == 'currentLocation');
        marks.add(Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(position!.latitude, position.longitude),
          
        ));
        update();
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
  }
}
