import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

Set<Polyline> polelineSetDriver = {};
Set<Marker> markerSetDriver = {};
bool showconfbox = true;

Future getPolylineDriver(context, lat, long, destlat, destlong) async {
  List<LatLng> polylineco = [];
  PolylinePoints polylinePoints = PolylinePoints();
  final status = await Permission.location.request();

  String url =
      "https://maps.googleapis.com/maps/api/directions/json?origin=$lat,$long&destination=$destlat,$destlong&key=AIzaSyCInTqCTY9b-p3Q2vtdZ9vJYH7ykKZJG6w";

  var response = await http.post(Uri.parse(url));
  var responsebody = jsonDecode(response.body);

  void showDialogWithMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  if (status.isGranted) {
    try {
      if (responsebody != null &&
          responsebody["routes"] != null &&
          responsebody["routes"].isNotEmpty) {
        var point = responsebody["routes"][0]["overview_polyline"]["points"];

        if (point != null) {
          List<PointLatLng> result = polylinePoints.decodePolyline(point);

          if (result.isNotEmpty) {
            // Adding markers at the beginning and end
            markerSetDriver.add(Marker(
              markerId: MarkerId("sourceMarker"),
              position: LatLng(lat, long),
              infoWindow: InfoWindow(title: "Source"),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            ));

            markerSetDriver.add(Marker(
              markerId: MarkerId("destinationMarker"),
              position: LatLng(destlat, destlong),
              infoWindow: InfoWindow(title: "Destination"),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ));

            result.forEach((PointLatLng point) {
              polylineco.add(LatLng(point.latitude, point.longitude));
            });
            Polyline polyline = Polyline(
                polylineId: PolylineId("polyline"),
                color: Colors.blue,
                points: polylineco,
                width: 5);

            polelineSetDriver.add(polyline);
          } else {
            // Handle case where 'result' is empty
            showDialogWithMessage('Result is empty');
            showconfbox = false;
          }
        } else {
          // Handle case where 'point' is null or empty
          showDialogWithMessage('Point is null or empty');
          showconfbox = false;
        }
      } else {
        // Handle case where 'routes' in the response is empty
        showDialogWithMessage('No routes found in response');
        showconfbox = false;
      }
    } catch (e) {
      showDialogWithMessage('An error occurred: $e');
      showconfbox = false;
    }
  } else if (status.isPermanentlyDenied) {
    openAppSettings(); // Open app settings if permission is permanently denied.
  }
}