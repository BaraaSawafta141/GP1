import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingController extends GetxController {
  StreamSubscription<Position>? positionStream;

  double? myPosLatitudetrack;
  double? myPoslongitudetrack;
  List<double> mypositionList = [];
  getCurrentLocation() {
     positionStream =  Geolocator.getPositionStream().listen((Position? position) {
      if (position != null) {
        myPosLatitudetrack = position.latitude;
        myPoslongitudetrack = position.longitude;
        print('$myPosLatitudetrack, $myPoslongitudetrack');
      }
    });
 
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }
}
