import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class TrackingController extends GetxController {
  StreamSubscription<Position>? positionStream;

  getCurrentLocation() {
    positionStream =
        Geolocator.getPositionStream().listen((Position? position) {
      print(position == null
          ? '==============================Unknown=============================='
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
  }

  @override
  void onInit() {
    getCurrentLocation();
    super.onInit();
  }
}
