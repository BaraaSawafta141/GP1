import 'dart:async';

import 'package:ecommercebig/view/screen/home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double? myposLastlati;
double? myposLastlong;

class TrackingController extends GetxController {
  StreamSubscription<Position>? positionStream;

  

  getCurrentLocation() {
    positionStream =
        Geolocator.getPositionStream().listen((Position? position) {
      print(
          'current position:=>> ${position?.latitude.toString()}, ${position?.longitude.toString()}');
      if (mymapcontroller != null) {
        myposLastlati = position!.latitude;
        myposLastlong = position.longitude;
        mymapcontroller
            ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(myposLastlati!, myposLastlong!),
          zoom: 15,
        )));
         marks.clear();
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
    getCurrentLocation();
    super.onInit();
  }
}
