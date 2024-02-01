import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
//import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercebig/controller/tracking/tracking_controller.dart';
import 'package:ecommercebig/core/functions/geocodingpolyline.dart';
import 'package:ecommercebig/core/middleware/mymiddleware.dart';
import 'package:ecommercebig/data/datasource/remote/driver/add_LatLong.dart';
import 'package:ecommercebig/data/datasource/remote/driver/approveRide.dart';
import 'package:ecommercebig/data/datasource/remote/driver/becomeAvailable.dart';
import 'package:ecommercebig/data/datasource/remote/driver/reserveDriver.dart';
import 'package:ecommercebig/data/datasource/remote/driver/viewDrivers.dart';
import 'package:ecommercebig/data/datasource/remote/payment/card.dart';
import 'package:ecommercebig/linkapi.dart';
import 'package:ecommercebig/view/screen/driver/chat/chat_view.dart';
import 'package:ecommercebig/view/screen/driver/driverdrawer.dart';
import 'package:ecommercebig/view/screen/driver/loginscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:location/location.dart' as lo;

import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';

// bool showdialog = false;
String? driverEmail;
String? drivername = "";
String? driverId;
String? driverPhoto = "";
double? myPosLatitude;
double? myPosLongitude;
cardData cardDetails = cardData(Get.find());
viewDriversData driversData = viewDriversData(Get.find());
List<String> cardsList = <String>[];
String selectedDriver = "";
final homePageMarkersdriver = <Marker>{}.obs;
addLatLong addlatlong = addLatLong(Get.find());
becomeAvailable becomeavailable =
    becomeAvailable(Get.find()); //become available
reserveDriverData notAvailable =
    reserveDriverData(Get.find()); //become not available
approveRide approve = approveRide(Get.find());
FirebaseFirestore firestore = FirebaseFirestore.instance;
sendMessageNotificaiton(String title, String message, String token, String type,
    String rideId) async {
  var headerslist = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAGgyANw4:APA91bEdUINe3cK1OHuaLJiC1atYC7-7EvPP-xKNKnZgwbXBnZSv3kOubwh7xiu2d2-Tamk0yv-itrEgHTfq6JE6URf3tf5Q4iPKG78RawCXTliqMpy_EqNie0g39VH5UaI7QKsqergX',
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  var body = {
    "to": token,
    "notification": {"title": title, "body": message},
    "data": {
      "type": type,
      "rideId": rideId,
      "token": await FirebaseMessaging.instance.getToken()
    },
    "android": {"priority": "high"},
  };
  var req = await http.post(url, headers: headerslist, body: jsonEncode(body));
  req.statusCode == 200 ? print("success") : print("error");
}

bool driverAvailable = true;
bool inARide = false;
String userToken = "";

class homedriver extends StatefulWidget {
  const homedriver({super.key});

  @override
  State<homedriver> createState() => driverHome();
}

void chat() async {
  firestore.collection('drivers').doc(driverId!).set({
    'id': driverId,
    'name': drivername,
    'token': await FirebaseMessaging.instance.getToken(),
  }, SetOptions(merge: true));
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
  String googleAPIKey = 'AIzaSyCInTqCTY9b-p3Q2vtdZ9vJYH7ykKZJG6w';

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(32.223295060141346, 35.237885713381246),
    zoom: 15,
  );

  TrackingController trackingController = TrackingController();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    FirebaseMessaging.instance.subscribeToTopic("drivers");
    super.initState();
    applyStoredMapTheme();
    driverId = driverServices.sharedPreferences.getString("id")!;
    driverEmail = driverServices.sharedPreferences.getString("email")!;
    drivername = driverServices.sharedPreferences.getString("name")!;
    driverPhoto = driverServices.sharedPreferences.getString("img")!;
    myServices.sharedPreferences.setString("homedriver", "1");
    chat();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        userToken = message.data['token'];
        if (message.data['type'] == 'ride_request') {
          // Assuming the message body format is 'From $Username, ${sourceController.text} to ${destinationController.text}'
          String messageBody = message.notification!.body!;
          // Split the message using ','
          List<String> parts = messageBody.split(',');
          // Extract the source and destination values
          String usernamePart = parts[0].trim(); // 'From $Username'
          String sourcePart = parts[1]
              .trim(); // '${sourceController.text} to ${destinationController.text}'
          // Extract source value
          String sourceValue = sourcePart.split(' to ')[0].trim();
          // Extract destination value
          String destinationValue = sourcePart.split(' to ')[1].trim();
          // Now you have the sourceValue and destinationValue
          print('Source: $sourceValue, Destination: $destinationValue');
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.bottomSlide,
            title: 'Ride Request',
            desc:
                'You have a new ride request from $sourceValue to $destinationValue',
            btnCancelText: 'Reject',
            btnCancelOnPress: () async {
              await becomeavailable.postdata(driverId!);
              print("=============================cancel");
              await sendMessageNotificaiton(
                  "Ride Request",
                  "Ride Request Rejected",
                  message.data['token'],
                  "ride_cancel",
                  message.data['rideId']);
              // Handle cancel action
            },
            btnOkText: 'Accept',
            btnOkOnPress: () async {
              var res = await approve.postdata(message.data['rideId']);
              if (res['status'] == 'success') {
                setState(() {
                  inARide = true;
                });
                print('========================ok');
                await getCurrentLocationWithoutCam();
                await sendMessageNotificaiton(
                    "Ride Request",
                    "Ride Request Accepted",
                    message.data['token'],
                    "ride_request",
                    message.data['rideId']);
                print(">> driver :" +
                    myPosLatitude.toString() +
                    " " +
                    myPosLongitude.toString());
                print(">> user :" +
                    message.data['lat'] +
                    " " +
                    message.data['long']);
                // Handle OK action
                // Get.to(() => chatViewDriver());
              }
            },
          ).show();
          await getPolyline(context, myPosLatitude, myPosLongitude,
              message.data['lat'], message.data['long']);
        } else {
          Get.snackbar(
            message.notification!.title!,
            message.notification!.body!,
            duration: const Duration(seconds: 5),
          );
        }
      }
    });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   if (message.notification != null) {
    //     if (message.data['type'] == 'ride_request') {
    //       AwesomeDialog(
    //         context: context,
    //         dialogType: DialogType.info,
    //         animType: AnimType.bottomSlide,
    //         title: 'Ride Request',
    //         desc: 'You have a new ride request',
    //         btnCancelText: 'Reject',
    //         btnCancelOnPress: () async {
    //           await becomeavailable.postdata(driverId!);
    //           print("=============================cancel");
    //           await sendMessageNotificaiton(
    //               "Ride Request",
    //               "Ride Request Rejected",
    //               message.data['token'],
    //               "ride_request",
    //               message.data['rideId']);
    //           // Handle cancel action
    //         },
    //         btnOkText: 'Accept',
    //         btnOkOnPress: () async {
    //           var res = await approve.postdata(message.data['rideId']);
    //           if (res['status'] == 'success') {
    //             setState(() {
    //               inARide = true;
    //             });
    //             userToken = message.data['token'];
    //             print('========================ok');
    //             await sendMessageNotificaiton(
    //                 "Ride Request",
    //                 "Ride Request Accepted",
    //                 message.data['token'],
    //                 "ride_request",
    //                 message.data['rideId']);
    //             // Handle OK action
    //             // Get.to(() => chatViewDriver());
    //           }
    //         },
    //       ).show();
    //     } else {
    //       Get.snackbar(
    //         message.notification!.title!,
    //         message.notification!.body!,
    //         duration: const Duration(seconds: 5),
    //       );
    //     }
    //   }
    // });
  }

  String? storedTheme;
  Future<void> applyStoredMapTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedTheme = prefs.getString('map_theme_d');
    print("$storedTheme<<<<Theme is<<<<<<<<");
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
  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  bool showListdst = false;
  double? dstlong;
  double? dstlati;

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
          final Uint8List markericon =
              await getBytesFromAssets('assets/images/4.png', 160);

          // Clear existing markers and add a new marker at the current location
          homePageMarkersdriver.clear();
          homePageMarkersdriver.add(Marker(
            markerId: MarkerId("currentLocation"),
            position: driverLocation,
            icon: BitmapDescriptor.fromBytes(markericon),
            infoWindow: InfoWindow(title: 'Your Location'),
          ));
          print(myPosLatitude);
          print(myPosLongitude);
          var res = await addlatlong.postdata(
              myPosLatitude.toString(), myPosLongitude.toString(), driverId);
          print("=======$res");
        }
      } catch (e) {
        print("Error getting current location: $e");
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> getCurrentLocationWithoutCam() async {
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
      child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              inARide == false
                  ? driverAvailable == false
                      ? MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.green,
                          minWidth: Get.width / 1.2,
                          height: 45,
                          onPressed: () {
                            becomeavailable.postdata(driverId!);
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.bottomSlide,
                              title: 'Become Available',
                              desc: 'You are now available for rides',
                            ).show();
                            setState(() {
                              driverAvailable = true;
                            });
                          },
                          child: Text(
                            "Become Available",
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        )
                      : MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.green,
                          minWidth: Get.width / 1.2,
                          height: 45,
                          onPressed: () {
                            notAvailable.postdata(driverId!);
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.bottomSlide,
                              title: 'Become Unavailable',
                              desc: 'You are now unavailable for rides',
                            ).show();
                            setState(() {
                              driverAvailable = false;
                            });
                          },
                          child: Text(
                            "Become Unavailable",
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        )
                  : MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.green,
                      minWidth: Get.width / 1.2,
                      height: 45,
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.bottomSlide,
                          title: 'End Ride',
                          desc: 'Are you sure you want to end this ride?',
                          btnCancelText: 'No',
                          btnCancelOnPress: () {},
                          btnOkText: 'Yes',
                          btnOkOnPress: () async {
                            await sendMessageNotificaiton("Ride Ended",
                                "Ride Ended", userToken, "ride_ended", "");
                            await notAvailable.postdata(driverId!);
                            setState(() {
                              inARide = false;
                              driverAvailable = false;
                            });
                          },
                        ).show();
                      },
                      child: Text(
                        "End Ride",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.green,
                minWidth: Get.width / 1.2,
                height: 45,
                onPressed: () {
                  getCurrentLocationIcon();
                },
                child: Text(
                  "Show Your Location",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ],
          )),
    );
  }
}
