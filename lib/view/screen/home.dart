import 'dart:async';
import 'dart:convert';

import 'dart:typed_data';
//import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercebig/controller/auth/login_controller.dart';
import 'package:ecommercebig/controller/tracking/tracking_controller.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/functions/geocodingpolyline.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/data/datasource/remote/driver/reserveDriver.dart';
import 'package:ecommercebig/data/datasource/remote/driver/viewDrivers.dart';
import 'package:ecommercebig/data/datasource/remote/payment/card.dart';
import 'package:ecommercebig/data/datasource/remote/userCords/user_cords.dart';
import 'package:ecommercebig/linkapi.dart';
import 'package:ecommercebig/view/screen/chat/test_view.dart';
import 'package:ecommercebig/view/screen/commentpage.dart';
import 'package:ecommercebig/view/screen/drawer.dart';

import 'package:ecommercebig/view/screen/ridehistory.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/directions.dart'
    as maps_directions;

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:location/location.dart' as lo;
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';

String? UserEmail;
String? Username;
String? Userphone;
String? Userid;
String? Userpass;
String? UserPhoto;
double? myPosLatitude;
double? myPoslongitude;
bool isLiveTrackingEnabled = false;
FirebaseFirestore firestore = FirebaseFirestore.instance;
cardData cardDetails = cardData(Get.find());
viewDriversData driversData = viewDriversData(Get.find());
reserveDriverData reserveDriver = reserveDriverData(Get.find());
addLatLongUser userCords = addLatLongUser(Get.find());
List<String> cardsList = <String>[];
List<Map<String, dynamic>> driversList = [];
String selectedDriver = driversList[0]["drivers_id"] != null
    ? driversList[0]["drivers_id"].toString()
    : "-1";
TextEditingController sourceController = TextEditingController();
TextEditingController destinationController = TextEditingController();

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => MapSampleState();
}

Set<Marker> marks = Set<Marker>();
GoogleMapController? mymapcontroller;
final homePageMarkers = <Marker>{}.obs;
bool showdialograting = true;

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
      "token": await FirebaseMessaging.instance.getToken(),
      "lat": myPosLatitude != null ? myPosLatitude : 0.0,
      "long": myPoslongitude != null ? myPoslongitude : 0.0,
      "source": sourceController.text != "" ? sourceController.text : "",
      "destination":
          destinationController.text != "" ? destinationController.text : "",
    },
  };
  var req = await http.post(url, headers: headerslist, body: jsonEncode(body));
  req.statusCode == 200 ? print("success") : print("error");
}

class MapSampleState extends State<home> {
  //final Completer<GoogleMapController> _controllergoogle =
  //  Completer<GoogleMapController>();
  Uint8List? markerImage;

  List<String> images = [
    // 'assets/images/1.png',
    // 'assets/images/2.png',
    // 'assets/images/3.png',
    'assets/images/4.png',
    // 'assets/images/5.png',
    // 'assets/images/6.png',
  ];
  late LatLng destination;
  late LatLng source;
  final List<Marker> _markers = <Marker>[];
  final List<LatLng> _latlng = <LatLng>[];

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void chat() async {
    firestore.collection('users').doc(Userid!).set({
      'uid': Userid,
      'name': Username,
      'token': await FirebaseMessaging.instance.getToken(),
    }, SetOptions(merge: true));
  }

  myRequestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(32.223295060141346, 35.237885713381246),
    zoom: 15,
  );

  TrackingController trackingController = TrackingController();
  TextEditingController controller = TextEditingController();
  String _sessionToken = '122344';
  List<dynamic> _placesList = [];

  @override
  void initState() {
    super.initState();
    myRequestPermission();
    applyStoredMapTheme();
    isLiveTrackingEnabled = false;
    UserEmail = userServices.sharedPreferences.getString("email")!;
    Username = userServices.sharedPreferences.getString("name")!;
    Userphone = userServices.sharedPreferences.getString("phone")!;
    Userid = userServices.sharedPreferences.getString("id")!;
    Userpass = userServices.sharedPreferences.getString("password")!;
    UserPhoto = userServices.sharedPreferences.getString("image");
    chat();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        if (message.data['type'] == 'ride_request') {
          AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.bottomSlide,
            title: 'Ride Accepted',
            desc: 'Your Ride Has Been Accepted, the driver is on his way',
            btnOkOnPress: () {},
          ).show();
        } else if (message.data['type'] == 'ride_cancel') {
          // if (mounted) {
          polelineSet.clear();
          homePageMarkers.clear();
          // Clear the text field
          sourceController.clear();
          destinationController.clear();
          AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.bottomSlide,
            title: 'Ride Cancelled',
            desc: 'Your Ride Has Been Cancelled',
            btnOkOnPress: () {
              // if (mounted) {
              Get.offAll(() => home());
              // }
            },
          ).show();
          // }
        } else if (message.data['type'] == 'ride_ended') {
          polelineSet.clear();
          homePageMarkers.clear();
          // Clear the text field
          sourceController.clear();
          destinationController.clear();
          AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.bottomSlide,
            title: 'Ride Ended',
            desc:
                'Your ride has ended, You can rate the driver in the ride history page',
            btnOkOnPress: () {
              // if (mounted) {
              Get.offAll(() => home());
              // }
            },
          ).show();
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
    //         dismissOnBackKeyPress: false,
    //         dismissOnTouchOutside: false,
    //         context: context,
    //         dialogType: DialogType.info,
    //         animType: AnimType.bottomSlide,
    //         title: 'Ride Accepted',
    //         desc: 'Your Ride Has Been Accepted, the driver is on his way',
    //         btnOkOnPress: () {},
    //       ).show();
    //     } else if (message.data['type'] == 'ride_cancel') {
    //       // if (mounted) {
    //       polelineSet.clear();
    //       homePageMarkers.clear();
    //       // Clear the text field
    //       sourceController.clear();
    //       destinationController.clear();
    //       AwesomeDialog(
    //         dismissOnBackKeyPress: false,
    //         dismissOnTouchOutside: false,
    //         context: context,
    //         dialogType: DialogType.info,
    //         animType: AnimType.bottomSlide,
    //         title: 'Ride Cancelled',
    //         desc: 'Your Ride Has Been Cancelled',
    //         btnOkOnPress: () {
    //           // if (mounted) {
    //           Get.offAll(() => home());
    //           // }
    //         },
    //       ).show();
    //       // }
    //     } else if (message.data['type'] == 'ride_ended') {
    //       polelineSet.clear();
    //       homePageMarkers.clear();
    //       // Clear the text field
    //       sourceController.clear();
    //       destinationController.clear();
    //       AwesomeDialog(
    //         dismissOnBackKeyPress: false,
    //         dismissOnTouchOutside: false,
    //         context: context,
    //         dialogType: DialogType.info,
    //         animType: AnimType.bottomSlide,
    //         title: 'Ride Ended',
    //         desc:
    //             'Your ride has ended, You can rate the driver in the ride history page',
    //         btnOkOnPress: () {
    //           // if (mounted) {
    //           Get.offAll(() => home());
    //           // }
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
    destinationController.addListener(() {
      onChangedest();
    });
    sourceController.addListener(() {
      onChangeSource();
    });
    loadData();
    _ratingController = TextEditingController(text: '3.0');
    _rating = _initialRating;
    WidgetsFlutterBinding.ensureInitialized();
  }

  String? storedTheme;
  Future<void> applyStoredMapTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedTheme = prefs.getString('map_theme');
    print("$storedTheme<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
  }

  loadData() async {
    _latlng.clear();
    driversList.clear();
    var response = await driversData.getData();
    statusrequest driversReq = handlingdata(response);
    List<dynamic> dataList = response['data'];
    if (statusrequest.success == driversReq) {
      if (response['status'] == "success") {
        for (var driver in dataList) {
          if (driver['drivers_availability'] == "0" &&
              driver['drivers_long'] != "0") {
            int driversId = driver['drivers_id'];
            String driversName = driver['drivers_name'];
            LatLng driverLocation = LatLng(double.parse(driver['drivers_lat']),
                double.parse(driver['drivers_long']));
            _latlng.add(driverLocation);
            // Create a map with the extracted information and add it to the list
            Map<String, dynamic> driverInfo = {
              'drivers_id': driversId,
              'drivers_name': driversName,
              'drivers_lat': driver['drivers_lat'],
              'drivers_long': driver['drivers_long'],
            };
            driversList.add(driverInfo);
          }
        }
        print(driversList);
      }
    } else {
      print("error in getting drivers Data");
    }
    for (int i = 0; i < driversList.length; i++) {
      final Uint8List markericon = await getBytesFromAssets(images[0], 140);
      homePageMarkers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: _latlng[i],
          icon: BitmapDescriptor.fromBytes(markericon),
          infoWindow: InfoWindow(title: driversList[i]['drivers_name'])));
      setState(() {});
    }
  }

  void onChangedest() {
    getSuggestionDest(destinationController.text);
  }

  void onChangeSource() {
    getSuggestionSource(sourceController.text);
  }

  void getSuggestionSource(String input) async {
    String places_key = "AIzaSyCInTqCTY9b-p3Q2vtdZ9vJYH7ykKZJG6w";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$places_key&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    print('data');
    print(data);

    if (response.statusCode == 200) {
      setState(() {
        sourcePlacesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('failed to load');
    }
  }

  void getSuggestionDest(String input) async {
    String places_key = "AIzaSyCInTqCTY9b-p3Q2vtdZ9vJYH7ykKZJG6w";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$places_key&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    print('data');
    print(data);

    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('failed to load');
    }
  }

  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      drawer: CustomDrawer(),
      /*appBar: AppBar(
        title: Text("maps"),
      ),*/
      body: Stack(
        children: [
          Positioned(
            /*top: 110,
            left: 0,
            right: 0,
            bottom: 0,*/

            child: Obx(() {
              Get.lazyPut<TrackingController>(() => TrackingController());
              final trackingController = Get.find<TrackingController>();
              final marks = trackingController.marks;
              // Combine the markers from both sources
              final allMarkers = {...homePageMarkers, ...marks};
              return GoogleMap(
                //myLocationButtonEnabled: true,
                //myLocationEnabled: true,
                polylines: polelineSet,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: Set<Marker>.from(allMarkers),
                //markers: Set<Marker>.of(_markers),
                onMapCreated: (GoogleMapController controller) async {
                  mymapcontroller = controller;
                  if (storedTheme != null) {
                    // Apply the stored theme using your mymapcontroller.setMapStyle method
                    String themePath = 'assets/maptheme/$storedTheme.txt';
                    mymapcontroller
                        ?.setMapStyle(await rootBundle.loadString(themePath));
                  }
                  // storedTheme!=Null?  mymapcontroller!.setMapStyle(storedTheme): //notyhi
                  //      mymapcontroller!.setMapStyle('assets/maptheme/silver.txt') ;
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
          buildTextField(destinationController, _placesList),
          //showSourceField ? buildTextFieldForSource() : Container(),
          //buildTextFieldForSource(sourceController, sourcePlacesList),
          customButtonSource(),
          buildCurrentLocationIcon(),
          // buildNotificationIcon(),
          buildBottomSheet(),
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
              color: Colors.blue[50],
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
                      image: UserPhoto == ""
                          ? AssetImage('assets/images/profile.png')
                              as ImageProvider<Object>
                          : NetworkImage(applink.linkImageRoot + '/$UserPhoto'),
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
                        text: Username,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ])),
                  Text(
                    "Where are you going ?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
        ));
  }

  bool showSourceField = false;
  double? srclong;
  double? srclati;
  bool isListOpen = false;
  bool showListsrc = false;
  List<dynamic> sourcePlacesList = [];

  Widget customButtonSource() {
    int itemCount = sourcePlacesList.length;
    double itemHeight = 50.0;

    return Column(
      children: [
        SizedBox(
          height: 110,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: Get.width,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 10,
                ),
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              readOnly: isBottomSheetOpen,
              onChanged: (value) {
                sourceController.text = value;
                getSuggestionSource(sourceController.text);
                setState(() {
                  showListsrc = true;
                });
              },
              onTap: () {
                Get.bottomSheet(SingleChildScrollView(
                  child: Container(
                    width: Get.width,
                    height: Get.height * 0.5,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Select Your Location:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // SizedBox(height: 10),

                        //SizedBox(height: 10),
                        Container(
                          width: Get.width,
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                spreadRadius: 4,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Current Location",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        //SizedBox(height: 10),
                        Container(
                          width: Get.width,
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                spreadRadius: 4,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  // homePageMarkers.add(
                                  // const  Marker(
                                  //     markerId:  MarkerId('currentLocation'),
                                  //     position:
                                  //         LatLng(0.0, 0.0), // Initial position.
                                  //     icon: BitmapDescriptor.defaultMarker,
                                  //   ),
                                  // );
                                  final trackingController =
                                      Get.find<TrackingController>();
                                  sourceController.text = "Current Location";
                                  showListsrc = false;
                                  trackingController.getCurrentLocation(); //<<
                                  Get.back();
                                },
                                child: Text(
                                  "My Location",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 80),
                        InkWell(
                          onTap: () {
                            Get.back();
                            isBottomSheetOpen = false;
                            sourceController.text = "";
                            //getSuggestion(sourceController.text);
                            Expanded(
                                child: ListView.builder(
                                    //shrinkWrap: true,
                                    itemCount: sourcePlacesList.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        onTap: () async {
                                          String selectplacesrc =
                                              sourcePlacesList[index]
                                                  ['description'];
                                          sourceController.text =
                                              sourcePlacesList[index]
                                                  ['description'];
                                          controller.clear();
                                          List<geoCoding.Location> locations =
                                              await geoCoding
                                                  .locationFromAddress(
                                                      sourcePlacesList[index]
                                                          ['description']);
                                          srclong = locations.last.longitude;
                                          srclati = locations.last.latitude;
                                          source = LatLng(
                                              locations.first.latitude,
                                              locations.first.longitude);
                                          homePageMarkers.add(Marker(
                                              markerId: MarkerId(
                                                  sourcePlacesList[index]
                                                      ['description']),
                                              infoWindow: InfoWindow(
                                                title:
                                                    'Source: $selectplacesrc',
                                                snippet:
                                                    'Latitude: $srclati, Longitude: $srclong',
                                              ),
                                              position: destination));
                                          mymapcontroller!.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                  CameraPosition(
                                                      target: source,
                                                      zoom: 15)));
                                        },
                                        title: Text(sourcePlacesList[index]
                                            ['description']),
                                      );
                                    }));
                          },
                          child: Container(
                            width: Get.width,
                            height: 70,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  spreadRadius: 4,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: Get.width * 0.7,
                                  padding: EdgeInsets.all(
                                      10), // Adjust padding as needed
                                  decoration: BoxDecoration(
                                    color: Colors.blue[
                                        200], // Replace with your desired background color
                                    borderRadius: BorderRadius.circular(
                                        20), // Adjust border radius as needed
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 44, 44,
                                          44), // Replace with your desired border color
                                      width: 1, // Adjust border width as needed
                                    ),
                                  ),
                                  child: Text(
                                    "Search For Address",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
              },
              controller: sourceController,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 10, left: 20),
                hintText: 'Search for a source',
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.search,
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Visibility(
          visible: showListsrc,
          child: SizedBox(
            height: itemCount * itemHeight,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(17)),
              margin: EdgeInsets.symmetric(horizontal: 17),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: sourcePlacesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      String selectplacesrc =
                          sourcePlacesList[index]['description'];
                      sourceController.text =
                          sourcePlacesList[index]['description'];
                      //destinationController.clear();
                      List<geoCoding.Location> locations =
                          await geoCoding.locationFromAddress(
                              sourcePlacesList[index]['description']);
                      srclong = locations.last.longitude;
                      srclati = locations.last.latitude;
                      source = LatLng(
                          locations.first.latitude, locations.first.longitude);
                      homePageMarkers.add(Marker(
                          markerId:
                              MarkerId(sourcePlacesList[index]['description']),
                          infoWindow: InfoWindow(
                              title: 'source: $selectplacesrc',
                              snippet:
                                  'Latitude: $srclati, Longitude: $srclong'),
                          position: source));
                      mymapcontroller!.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: source, zoom: 15)));
                      print(locations.last.latitude);
                      print(locations.last.longitude);
                      sourcePlacesList.removeAt(index);
                      setState(() {
                        showListsrc = false;
                      });
                    },
                    title: Text(sourcePlacesList[index]['description']),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool showListdst = false;
  double? dstlong;
  double? dstlati;
  Widget buildTextField(destinationController, List _placesList) {
    int itemCount = _placesList.length;
    double itemHeight = 50.0;

    return Column(
      children: [
        SizedBox(
          height: 170,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: Get.width,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 10,
                ),
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              onChanged: (value) {
                destinationController.text = value;
                getSuggestionDest(destinationController.text);
                setState(() {
                  showListdst = true;
                });
              },
              controller: destinationController,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 10, left: 20),
                hintText: 'Search for a destination',
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.search,
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Visibility(
          visible: showListdst,
          child: SizedBox(
            height: itemCount * itemHeight,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.symmetric(horizontal: 17),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _placesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      driversList.clear();
                      var response = await driversData.getData();
                      statusrequest driversReq = handlingdata(response);
                      List<dynamic> dataList = response['data'];
                      if (statusrequest.success == driversReq) {
                        if (response['status'] == "success") {
                          for (var driver in dataList) {
                            int driversId = driver['drivers_id'];
                            String driversName = driver['drivers_name'];
                            // Create a map with the extracted information and add it to the list
                            Map<String, dynamic> driverInfo = {
                              'drivers_id': driversId,
                              'drivers_name': driversName
                            };
                            driversList.add(driverInfo);
                          }
                          print(driversList);
                        }
                      } else {
                        print("error in getting drivers Data");
                      }

                      var cards = await cardDetails.getdata();
                      print("===================== $cards ");
                      statusrequest statusreq = handlingdata(cards);
                      print("\n$statusreq\n");
                      if (statusrequest.success == statusreq) {
                        if (cards['status'] == "success") {
                          setState(() {
                            for (int i = 0; i < cards['data'].length; i++) {
                              cardsList.add(cards['data'][i]['card_number']);
                            }
                          });
                          print(
                              "============================ cccccctttttttttttttttttttttttttttttttttttttttcccccc $cardsList ");
                        }
                      } else {
                        print("error in getting cards");
                      }

                      String selectplacedest =
                          _placesList[index]['description'];
                      destinationController.text =
                          _placesList[index]['description'];
                      //sourceController.clear();
                      List<geoCoding.Location> locations =
                          await geoCoding.locationFromAddress(
                              _placesList[index]['description']);
                      dstlong = locations.last.longitude;
                      dstlati = locations.last.latitude;
                      destination = LatLng(
                          locations.first.latitude, locations.first.longitude);
                      homePageMarkers.add(Marker(
                          markerId: MarkerId(_placesList[index]['description']),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueBlue),
                          infoWindow: InfoWindow(
                              title: 'destination: $selectplacedest',
                              snippet:
                                  'Latitude: $dstlati, Longitude: $dstlong'),
                          position: destination));
                      mymapcontroller!.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: destination, zoom: 15)));

                      //drawPolyline(selectplacedest);
                      await getPolyline(
                          context,
                          srclati == null ? myposLastlati : srclati,
                          srclong == null ? myposLastlong : srclong,
                          dstlati,
                          dstlong);
                      //    final trackingController = Get.find<TrackingController>();
                      //   trackingController.getCurrentLocation();
                      print(locations.last.latitude);
                      print(locations.last.longitude);
                      _placesList.removeAt(index);
                      setState(() {
                        showListdst = false;
                        if (showconfbox == true) {
                          buildRideConfirmationSheet();
                        } else {}
                      });
                    },
                    title: Text(_placesList[index]['description']),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool isBottomSheetOpen = false;

  Future<void> getCurrentLocationIcon() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        if (mymapcontroller != null) {
          myPosLatitude = position.latitude;
          myPoslongitude = position.longitude;
          LatLng userLocation = LatLng(position.latitude, position.longitude);
          mymapcontroller!.animateCamera(
            CameraUpdate.newLatLng(userLocation),
          );
          print(myPosLatitude);
          print(myPoslongitude);
          userCords.postdata(
              myPosLatitude.toString(), myPoslongitude.toString(), Userid);
        }
      } catch (e) {
        print("Error getting current location: $e");
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Open app settings if permission is permanently denied.
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
          myPoslongitude = position.longitude;
          LatLng userLocation = LatLng(position.latitude, position.longitude);
          userCords.postdata(
              myPosLatitude.toString(), myPoslongitude.toString(), Userid);
        }
      } catch (e) {
        print("Error getting current location: $e");
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Open app settings if permission is permanently denied.
    }
  }

  Widget buildCurrentLocationIcon() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 10),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue,
          child: IconButton(
            icon: Icon(
              Icons.my_location,
              color: Colors.white,
            ),
            onPressed: () {
              getCurrentLocationIcon();
            },
          ),
        ),
      ),
    );
  }

  Widget buildNotificationIcon() {
    return const Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40, left: 10),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.notifications_none,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: Get.width * 0.8,
        height: 25,
        decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 10),
            ]),
        child: Center(
          child: Container(
            width: Get.width * 0.6,
            height: 4,
            color: Colors.black45,
          ),
        ),
      ),
    );
  }

  buildRideConfirmationSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.4,
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: Get.width * 0.2,
              height: 8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Select an option:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          buildDriversList(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: buildPaymentCardWidget()),
                MaterialButton(
                  onPressed: () async {
                    if (showdialograting) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Driver Rating'),
                          content: const Text(
                              'Do You Want To See The Driver Rating '),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'Cancel');
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context, 'OK');
                                var result = await Get.to(commentpage());
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text("Check"),
                  color: Colors.green,
                  shape: StadiumBorder(),
                ),
                SizedBox(
                  width: 5,
                ),
                MaterialButton(
                  onPressed: () async {
                    if (showdialograting) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Confirm Ride'),
                          content:
                              const Text('Confirm The Ride With The Driver ?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'No');
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await getCurrentLocationWithoutCam();
                                // setState(() {
                                //   RideCount++;
                                // });
                                // getCurrentLocationIcon();
                                String rideId = await saveRideHistory(
                                  sourceController.text,
                                  destinationController.text,
                                  DateTime.now().toString(),
                                  selectedDriver,
                                );
                                userCords.postdata(myPosLatitude.toString(),
                                    myPoslongitude.toString(), Userid);
                                // print("+++++++ $selectedDriver");
                                var res = await reserveDriver
                                    .postdata(selectedDriver);
                                // print(" >> $res");
                                String? driverToken =
                                    await getDriverToken(selectedDriver);
                                await sendMessageNotificaiton(
                                    'You have a new ride request!',
                                    'Ride Request',
                                    driverToken!,
                                    'ride_request',
                                    rideId);
                                Navigator.pop(context, 'Yes');
                                Get.back();
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text("Confirm"),
                  color: Colors.green,
                  shape: StadiumBorder(),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  late final _ratingController;
  late double _rating;

  double _userRating = 3.0;
  int _ratingBarMode = 1;
  double _initialRating = 2.0;
  bool _isRTLMode = false;
  bool _isVertical = false;

  IconData? _selectedIcon;

  void buildRatingAndCommentSheet() {
    Get.bottomSheet(
      Container(
        width: Get.width,
        //height: Get.height * 0.4,
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          ),
        ),
        child: Builder(
          builder: (context) => Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                  ),
                  _heading('Rate the driver'),
                  _ratingBar(_ratingBarMode),
                  SizedBox(height: 20.0),
                  Text(
                    'Rating: $_rating',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Rating Bar Modes',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _radio(1),
                      _radio(3),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Center(
                      //padding: const EdgeInsets.all(15),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Add a comment',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                        // You can store the comment in a variable.
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 40,
                    width: 200,
                    child: MaterialButton(
                        color: Colors.blue,
                        child: Text(
                          "Submit",
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {}),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _radio(int value) {
    return Expanded(
      child: RadioListTile<int>(
        value: value,
        groupValue: _ratingBarMode,
        dense: true,
        title: Text(
          'Mode $value',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 14.0,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _ratingBarMode = value!;
          });
        },
      ),
    );
  }

  Widget _ratingBar(int mode) {
    switch (mode) {
      case 1:
        return RatingBar.builder(
          initialRating: _initialRating,
          minRating: 1,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: true,
          unratedColor: Colors.blue.withAlpha(50),
          itemCount: 5,
          itemSize: 50.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            _selectedIcon ?? Icons.star,
            color: Colors.blue,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        );
      case 3:
        print("========================Case 2=========================== ");
        return RatingBar.builder(
          initialRating: _initialRating,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return Icon(
                  Icons.sentiment_neutral,
                  color: Colors.blue,
                );
              case 3:
                return Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
              default:
                return Container();
            }
          },
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        );
      default:
        return Container();
    }
  }

  Widget _heading(String text) => Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      );

  int selectedRide = 0;
  Future<void> updateLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    myPosLatitude = position.latitude;
    myPoslongitude = position.longitude;
  }

  Future<double> calculateDistance(
      double lat1, double lon1, double lat2, double lon2) async {
    return await Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  Future<void> sortDriversByDistance(List<LatLng> drivers) async {
    await updateLocation();

    // Use Future.wait to wait for all distance calculations to complete
    List<double> distances = await Future.wait(drivers.map((driver) async {
      return await calculateDistance(
          myPosLatitude!, myPoslongitude!, driver.latitude, driver.longitude);
    }));

    // Pair each driver with its distance and sort based on distance
    List<Map<String, dynamic>> driverDistancePairs = [];
    for (int i = 0; i < drivers.length; i++) {
      driverDistancePairs.add({'driver': drivers[i], 'distance': distances[i]});
    }

    driverDistancePairs.sort((a, b) => a['distance'].compareTo(b['distance']));

    // Update the order of drivers based on the sorted distances
    drivers.clear();
    for (var pair in driverDistancePairs) {
      drivers.add(pair['driver']);
    }
    //print("==================${driverDistancePairs}=====================");
  }

  buildDriversList() {
    // Call sortDriversByDistance to update the order of drivers based on distance
    // sortDriversByDistance(_latlng); //we have to implement a function to get the drivers lat and long
    return Container(
      height: 120,
      width: Get.width,
      child: StatefulBuilder(builder: (context, set) {
        return ListView.builder(
          itemBuilder: (ctx, i) {
            return InkWell(
              onTap: () async {
                set(() {
                  selectedRide = i;
                  selectedDriver = driversList[i]['drivers_id'].toString();
                });
              },
              child: buildDriverCard(selectedRide == i, i),
            );
          },
          itemCount: driversList.length,
          scrollDirection: Axis.horizontal,
        );
      }),
    );
  }

  /*buildDriversList() {
    return Container(
      height: 120,
      width: Get.width,
      child: StatefulBuilder(builder: (context, set) {
        return ListView.builder(
          itemBuilder: (ctx, i) {
            return InkWell(
              onTap: () async {
                set(() {
                  selectedRide = i;
                });
              },
              child: buildDriverCard(selectedRide == i),
            );
          },
          itemCount: images.length,
          scrollDirection: Axis.horizontal,
        );
      }),
    );
  }*/

  Future<String?> getDriverToken(String driverId) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference driversCollection =
          FirebaseFirestore.instance.collection('drivers');
      // Get the document snapshot for the specified driver ID
      DocumentSnapshot driverDocument =
          await driversCollection.doc(driverId).get();
      // Check if the document exists
      if (driverDocument.exists) {
        // Retrieve the 'token' field from the document data
        String? driverToken = driverDocument.get('token');
        // Return the driver's token
        return driverToken;
      } else {
        // Driver document with the specified ID not found
        print('Driver with ID $driverId not found.');
        return null;
      }
    } catch (e) {
      // Handle any errors that occurred during the process
      print('Error fetching driver token: $e');
      return null;
    }
  }

  buildDriverCard(bool selected, int i) {
    return Container(
      margin: EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
      height: 85,
      width: 165,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: selected
                    ? Color(0xff2DBB54).withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                offset: Offset(0, 5),
                blurRadius: 5,
                spreadRadius: 1)
          ],
          borderRadius: BorderRadius.circular(12),
          color: selected ? Color(0xff2DBB54) : Colors.grey),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driversList[i]['drivers_name'],
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
                Text(
                  '\$9.90',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                Text(
                  '3 MIN',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
              ],
            ),
          ),
          Positioned(
              right: -20,
              top: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/carcard.png',
                width: 100,
                height: 70,
              ))
        ],
      ),
    );
  }

  buildPaymentCardWidget() {
    String dropdownValue =
        cardsList.length != 0 ? cardsList.first : "No Cards Found";
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/visa.png',
            width: 40,
          ),
          SizedBox(
            width: 10,
          ),
          // DropdownButton<String>(
          //   value: dropdownValue,
          //   icon: const Icon(Icons.keyboard_arrow_down),
          //   elevation: 16,
          //   style:  TextStyle(color: Colors.deepPurple),
          //   underline: Container(),
          //   onChanged: (String? value) {
          //     // This is called when the user selects an item.
          //     setState(() {
          //       dropdownValue = value!;
          //     });
          //   },
          //   items: cardsList.map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value,
          //           style: TextStyle(
          //             fontSize: 11,
          //           )),
          //     );
          //   }).toList(),
          // ),
          DropdownMenu<String>(
            width: Get.width * 0.3,
            initialSelection: dropdownValue,
            onSelected: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },
            dropdownMenuEntries:
                cardsList.map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(value: value, label: value);
            }).toList(),
          )
        ],
      ),
    );
  }
}
