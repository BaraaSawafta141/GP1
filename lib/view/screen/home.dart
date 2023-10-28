import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
//import 'dart:html';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ecommercebig/view/screen/auth/custombuttonsource.dart';
import 'package:ecommercebig/view/screen/myprofile.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';


class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => MapSampleState();
}

class MapSampleState extends State<home> {
  final Completer<GoogleMapController> _controllergoogle =
      Completer<GoogleMapController>();

  String? _mapStyle;

  Uint8List? markerImage;

  List<String> images = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
    'assets/images/4.png',
    'assets/images/5.png',
    'assets/images/6.png',
  ];
  late LatLng destination;
  late LatLng source;
  Set<Marker> marks = Set<Marker>();

  final List<Marker> _markers = <Marker>[];
  final List<LatLng> _latlng = <LatLng>[
    LatLng(32.223295060141346, 35.237885713381246),
    LatLng(32.22376702872116, 35.239902734459896),
    LatLng(32.22108040562581, 35.23814320546564),
    LatLng(32.22535466270865, 35.24139978035635),
    LatLng(32.22117751845855, 35.24213979128875),
    LatLng(32.22074576133657, 35.2327620677686),
  ];
  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  /*void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }*/

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(32.223295060141346, 35.237885713381246),
    zoom: 15,
  );

  GoogleMapController? mymapcontroller;

  TextEditingController controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    destinationController.addListener(() {
      onChangedest();
    });
    sourceController.addListener(() {
      onChangeSource();
    });
    customButtonSource();
    loadData();
  }

  loadData() async {
    for (int i = 0; i < images.length; i++) {
      final Uint8List markericon = await getBytesFromAssets(images[i], 140);
      marks.add(Marker(
          markerId: MarkerId(i.toString()),
          position: _latlng[i],
          icon: BitmapDescriptor.fromBytes(markericon),
          infoWindow: InfoWindow(title: 'Driver ' + i.toString())));
      setState(() {});
    }
  }

  void onChangedest() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken == uuid.v4();
      });
    }

    getSuggestionDest(destinationController.text);
  }

  void onChangeSource() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken == uuid.v4();
      });
    }

    getSuggestionSource(sourceController.text);
  }

  void getSuggestionSource(String input) async {
    String places_key = "AIzaSyAWw0O5296K5kLNisnYj5YiRBKzMh5Dpq4";
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
    String places_key = "AIzaSyAWw0O5296K5kLNisnYj5YiRBKzMh5Dpq4";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
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
            child: GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              markers: marks,
              //markers: Set<Marker>.of(_markers),
              onMapCreated: (GoogleMapController controller) {
                mymapcontroller = controller;
                mymapcontroller!.setMapStyle(_mapStyle);
              },
            ),
          ),
          buildProfileTile(),
          buildTextField(destinationController, _placesList),
          //showSourceField ? buildTextFieldForSource() : Container(),
          //buildTextFieldForSource(sourceController, sourcePlacesList),
          customButtonSource(),
          buildCurrentLocationIcon(),
          buildNotificationIcon(),
          buildBottomSheet(),
        ],
      ),
    );
  }

  Widget buildProfileTile() {
    return Positioned(
        top: 35,
        left: 50,
        right: 20,
        child: Container(
          width: Get.width,
          //color: Colors.transparent,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  //color: Colors.red,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/images/lang.png'),
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
                        text: "Mark",
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

  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  bool showSourceField = false;
  double? srclong;
  double? srclati;

  Widget customButtonSource() {
    int itemCount = sourcePlacesList.length;
    double itemHeight = 50.0;
    bool showList = itemCount > 0;
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
              onChanged: (value) {
                sourceController.text = value;
                getSuggestionSource(sourceController.text);
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
          visible: showList,
          child: SizedBox(
            height: itemCount * itemHeight,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sourcePlacesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    String selectplacedest =
                        sourcePlacesList[index]['description'];
                    sourceController.text =
                        sourcePlacesList[index]['description'];
                    destinationController.clear();
                    List<geoCoding.Location> locations =
                        await geoCoding.locationFromAddress(
                            sourcePlacesList[index]['description']);
                    srclong = locations.last.latitude;
                    srclati = locations.last.longitude;
                    source = LatLng(
                        locations.first.latitude, locations.first.longitude);
                    marks.add(Marker(
                        markerId:
                            MarkerId(sourcePlacesList[index]['description']),
                        infoWindow: InfoWindow(
                            title: 'destination: $selectplacedest',
                            snippet: 'Latitude: $srclati, Longitude: $srclong'),
                        position: source));
                    mymapcontroller!.animateCamera(
                        CameraUpdate.newCameraPosition(
                            CameraPosition(target: source, zoom: 15)));

                    print(locations.last.latitude);
                    print(locations.last.longitude);
                    sourcePlacesList.removeAt(index);
                  },
                  title: Text(sourcePlacesList[index]['description']),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextField(destinationController, List _placesList) {
    double dstlong;
    double dstlati;
    int itemCount = _placesList.length;
    double itemHeight = 50.0;

    bool showList =
        itemCount > 0; // Flag to determine if the list should be shown

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
          visible: showList,
          child: SizedBox(
            height: itemCount * itemHeight,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _placesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    String selectplacedest = _placesList[index]['description'];
                    destinationController.text =
                        _placesList[index]['description'];
                    sourceController.clear();
                    List<geoCoding.Location> locations = await geoCoding
                        .locationFromAddress(_placesList[index]['description']);
                    dstlong = locations.last.latitude;
                    dstlati = locations.last.longitude;
                    destination = LatLng(
                        locations.first.latitude, locations.first.longitude);
                    marks.add(Marker(
                        markerId: MarkerId(_placesList[index]['description']),
                        infoWindow: InfoWindow(
                            title: 'destination: $selectplacedest',
                            snippet: 'Latitude: $dstlati, Longitude: $dstlong'),
                        position: destination));
                    mymapcontroller!.animateCamera(
                        CameraUpdate.newCameraPosition(
                            CameraPosition(target: destination, zoom: 15)));

                    print(locations.last.latitude);
                    print(locations.last.longitude);
                    _placesList.removeAt(index);
                  },
                  title: Text(_placesList[index]['description']),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<dynamic> sourcePlacesList = [];
  bool isBottomSheetOpen = false;

  /*Widget buildTextFieldForSource(sourceController, List sourcePlacesList) {
    double srclong;
    double srclati;
    return Positioned(
      top: 110,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 10)
            ],
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          controller: sourceController,
          readOnly: isBottomSheetOpen,
          onChanged: (value) {
            sourceController.text = value;
            getSuggestionDest(sourceController.text);
          },
          onTap: () async {
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Home Address",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
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
                      child: const Row(
                        children: [
                          Text(
                            "My Home",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "University Address",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
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
                      child: const Row(
                        children: [
                          Text(
                            "My University",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Get.back();
                        isBottomSheetOpen = false;
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
                                          await geoCoding.locationFromAddress(
                                              sourcePlacesList[index]
                                                  ['description']);
                                      srclong = locations.last.longitude;
                                      srclati = locations.last.latitude;
                                      source = LatLng(locations.first.latitude,
                                          locations.first.longitude);
                                      marks.add(Marker(
                                          markerId: MarkerId(
                                              sourcePlacesList[index]
                                                  ['description']),
                                          infoWindow: InfoWindow(
                                            title: 'Source: $selectplacesrc',
                                            snippet:
                                                'Latitude: $srclati, Longitude: $srclong',
                                          ),
                                          position: destination));
                                      mymapcontroller!.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                  target: source, zoom: 15)));
                                    },
                                    title: Text(
                                        sourcePlacesList[index]['description']),
                                  );
                                }));
                      },
                      child: Container(
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Search For Address",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
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
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: 'From:',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }*/

/*Future<void> getCurrentLocation() async {
  var status = await Permission.location.status;
  if (status.isDenied) {
    await Permission.location.request();
  }

  if (status.isGranted) {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      if (mymapcontroller != null) {
        mymapcontroller!.animateCamera(CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ));
      }
    } catch (e) {
      print("Error getting current location: $e");
    }
  }
}*/

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
             // getCurrentLocation();
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

  buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => MyProfile());
            },
            child: SizedBox(
              height: 150,
              child: DrawerHeader(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/lang.png'))),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Good Morning, ',
                            style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.28),
                                fontSize: 14)),
                        Text(
                          /*authController.myUser.value.name == null
                              ? "Mark"
                              : authController.myUser.value.name!,*/
                          "Mark",
                          style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                      ],
                    ),
                  )
                ],
              )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                buildDrawerItem(
                    title: 'Payment History',
                    onPressed: () {} /*=> Get.to(()=> PaymentScreen())*/),
                buildDrawerItem(
                    title: 'Ride History', onPressed: () {}, isVisible: true),
                buildDrawerItem(title: 'Invite Friends', onPressed: () {}),
                buildDrawerItem(title: 'Promo Codes', onPressed: () {}),
                buildDrawerItem(title: 'Settings', onPressed: () {}),
                buildDrawerItem(title: 'Support', onPressed: () {}),
                buildDrawerItem(
                    title: 'Log Out',
                    onPressed: () {
                      //FirebaseAuth.instance.signOut();
                    }),
              ],
            ),
          ),
          Spacer(),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: [
                buildDrawerItem(
                    title: 'Do more',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    height: 20),
                const SizedBox(
                  height: 20,
                ),
                buildDrawerItem(
                    title: 'Get food delivery',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    height: 20),
                buildDrawerItem(
                    title: 'Make money driving',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    height: 20),
                buildDrawerItem(
                  title: 'Rate us on store',
                  onPressed: () {},
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  height: 20,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  buildDrawerItem(
      {required String title,
      required Function onPressed,
      Color color = Colors.black,
      double fontSize = 20,
      FontWeight fontWeight = FontWeight.w700,
      double height = 45,
      bool isVisible = false}) {
    return SizedBox(
      height: height,
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        // minVerticalPadding: 0,
        dense: true,
        onTap: () => onPressed(),
        title: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: fontWeight, color: color),
            ),
            const SizedBox(
              width: 5,
            ),
            isVisible
                ? CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 15,
                    child: Text(
                      '1',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
