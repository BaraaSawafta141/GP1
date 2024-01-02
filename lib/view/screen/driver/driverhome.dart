import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
//import 'dart:html';
import 'package:ecommercebig/controller/auth/login_controller.dart';
import 'package:ecommercebig/controller/tracking/tracking_controller.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/functions/geocodingpolyline.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/core/middleware/mymiddleware.dart';
import 'package:ecommercebig/data/datasource/remote/driver/viewDrivers.dart';
import 'package:ecommercebig/data/datasource/remote/payment/card.dart';
import 'package:ecommercebig/linkapi.dart';
import 'package:ecommercebig/view/screen/commentpage.dart';
import 'package:ecommercebig/view/screen/drawer.dart';
import 'package:ecommercebig/view/screen/driver/driverdrawer.dart';
import 'package:ecommercebig/view/screen/driver/driverprofile.dart';
import 'package:ecommercebig/view/screen/maptheme.dart';
import 'package:ecommercebig/view/screen/rating_driver.dart';
import 'package:ecommercebig/view/screen/ridehistory.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/directions.dart'
    as maps_directions;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:location/location.dart' as lo;
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';

String? driverEmail;
String? drivername = "";

String? Userpass;
String? driverPhoto = "";
cardData cardDetails = cardData(Get.find());
viewDriversData driversData = viewDriversData(Get.find());
List<String> cardsList = <String>[];
String selectedDriver = "";
final homePageMarkersdriver = <Marker>{}.obs;

class homedriver extends StatefulWidget {
  const homedriver({super.key});

  @override
  State<homedriver> createState() => driverHome();
}

Set<Marker> marks = Set<Marker>();
GoogleMapController? mymapcontroller;
final homePageMarkers = <Marker>{}.obs;
bool showdialograting = true;

class driverHome extends State<homedriver> {
  late LatLng destination;
  late LatLng source;

  List<Map<String, dynamic>> driversList = [];

  @override
  String googleAPIKey = 'AIzaSyAWw0O5296K5kLNisnYj5YiRBKzMh5Dpq4';

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(32.223295060141346, 35.237885713381246),
    zoom: 15,
  );

  TrackingController trackingController = TrackingController();
  TextEditingController controller = TextEditingController();

  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    applyStoredMapTheme();
    // driverId = driverServices.sharedPreferences.getString("id")!;
    driverEmail = driverServices.sharedPreferences.getString("email")!;
    drivername = driverServices.sharedPreferences.getString("name")!;
    driverPhoto = driverServices.sharedPreferences.getString("img")!;
    myServices.sharedPreferences.setString("homedriver", "1");
  }

  String? storedTheme;
  Future<void> applyStoredMapTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedTheme = prefs.getString('map_theme_d');
    print("$storedTheme<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
  }

  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      drawer: CustomDrawerDriver(),
      body: Stack(
        children: [
          Positioned(
            child: Obx(() {
              Get.lazyPut<TrackingController>(() => TrackingController());
              final trackingController = Get.find<TrackingController>();
              final marks = trackingController.marks;
              return GoogleMap(
                polylines: polelineSet,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: Set<Marker>.from(homePageMarkersdriver),
                //markers: Set<Marker>.of(_markers),
                onMapCreated: (GoogleMapController controller) async {
                  mymapcontroller = controller;
                  if (storedTheme != null) {
                    String themePath = 'assets/maptheme/$storedTheme.txt';
                    mymapcontroller
                        ?.setMapStyle(await rootBundle.loadString(themePath));
                  }
                },
              );
            }),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: InkWell(
              onTap: () {
                scaffoldkey.currentState!.openDrawer();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 4,
                          blurRadius: 10)
                    ]),
                child: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          buildProfileTile(),
          buildCurrentLocationmarker(),
        ],
      ),
    );
  }

  Widget buildProfileTile() {
    return Positioned(
        top: 35,
        left: 70,
        right: 20,
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 212, 248, 214),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  //color: Colors.red,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: driverPhoto == ""
                          ? AssetImage('assets/images/profile.png')
                              as ImageProvider<Object>
                          : NetworkImage(
                              applink.linkImageRoot + '/$driverPhoto'),
                      fit: BoxFit.fill),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Hello, ",
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                    TextSpan(
                        text: drivername,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ])),
                  Row(
                    children: [
                      Text(
                        "Online",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        color: Colors.green,
                        Icons.wifi_outlined,
                        size: 24,
                      )
                      // Icon(Icons.wifi_off_outlined)
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }

  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  List<dynamic> sourcePlacesList = [];

  bool showListdst = false;
  double? dstlong;
  double? dstlati;

  double? myPosLatitude;
  double? myPosLongitude;
  Future<void> getCurrentLocationIcon() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        if (mymapcontroller != null) {
          myPosLatitude = position.latitude;
          myPosLongitude = position.longitude;
          LatLng driverLocation = LatLng(position.latitude, position.longitude);
          mymapcontroller!.animateCamera(
            CameraUpdate.newLatLng(driverLocation),
          );

          // Clear existing markers and add a new marker at the current location
          homePageMarkersdriver.clear();
          homePageMarkersdriver.add(Marker(
            markerId: MarkerId("currentLocation"),
            position: driverLocation,
            icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(5.0, 5.0)),
              'assets/images/4.png',
            ),
            infoWindow: InfoWindow(title: 'Your Location'),
          ));
          print(myPosLatitude);
          print(myPosLongitude);
        }
      } catch (e) {
        print("Error getting current location: $e");
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Widget buildCurrentLocationmarker() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
          padding: EdgeInsets.all(30),
          child: MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.green,
            minWidth: Get.width,
            height: 50,
            onPressed: () {
              getCurrentLocationIcon();
            },
            child: Text(
              "Show Your Location",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          )),
    );
  }
}
