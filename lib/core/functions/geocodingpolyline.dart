import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

Set<Polyline> polelineSet = {};

Future getPolyline(lat, long, destlat, destlong) async {
  List<LatLng> polylineco = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String url =
      "https://maps.googleapis.com/maps/api/directions/json?origin=$lat,$long&destination=$destlat,$destlong&key=AIzaSyAWw0O5296K5kLNisnYj5YiRBKzMh5Dpq4";
  var response = await http.post(Uri.parse(url));

  var responsebody = jsonDecode(response.body);

  var point = responsebody["routes"][0]["overview_polyline"]["points"];

  List<PointLatLng> result = polylinePoints.decodePolyline(point);

  if (result.isNotEmpty) {
    result.forEach((PointLatLng point) {
      polylineco.add(LatLng(point.latitude, point.longitude));
    });
  }

  Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: Colors.blue,
      points: polylineco,
      width: 5);

  polelineSet.add(polyline);
}
