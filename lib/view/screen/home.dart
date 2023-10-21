import 'dart:async';
import 'dart:convert';
//import 'dart:html';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => MapSampleState();
}

class MapSampleState extends State<home> {
  final Completer<GoogleMapController> _controllergoogle =
      Completer<GoogleMapController>();

  String? _mapStyle;

  @override
  /*void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }*/

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(32.32982, 35.36771),
    zoom: 14.5,
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
    controller.addListener(() {
      onChange();
    });
    _controller2.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken == uuid.v4();
      });
    }

    getSuggestion(controller.text);
  }

  void getSuggestion(String input) async {
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
        sourcePlacesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                mymapcontroller = controller;
                mymapcontroller!.setMapStyle(_mapStyle);
              },
            ),
          ),
          buildProfileTile(),
          buildTextField(controller, _placesList),
          //showSourceField ? buildTextFieldForSource() : Container(),
          buildTextFieldForSource(sourceController, sourcePlacesList),
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

  bool showSourceField = false;
  Widget buildTextField( controller, List _placesList) {
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
              controller: controller,
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
                    controller.text = _placesList[index]['description'];
                    sourceController.clear();
                    List<Location> locations = await locationFromAddress(
                        _placesList[index]['description']);
                    print(locations.last.longitude);
                    print(locations.last.latitude);
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
  Widget buildTextFieldForSource(sourceController,List sourcePlacesList) {
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
            getSuggestion(sourceController.text);
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
                                      sourceController.text = sourcePlacesList[index]['description'];
                                      controller.clear(); 
                                      List<Location> locations =
                                          await locationFromAddress(
                                              sourcePlacesList[index]
                                                  ['description']);
                                      print(locations.last.longitude);
                                      print(locations.last.latitude);
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
  }

  Widget buildCurrentLocationIcon() {
    return const Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 10),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.my_location,
            color: Colors.white,
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
}
