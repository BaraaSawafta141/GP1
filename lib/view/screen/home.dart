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

  TextEditingController _controller = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken == uuid.v4();
      });
    }

    getSuggestion(_controller.text);
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
              //zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                mymapcontroller = controller;
                mymapcontroller!.setMapStyle(_mapStyle);
              },
            ),
          ),
          buildProfileTile(),
          buildTextField1(_controller, _placesList),
          buildCurrentLocationIcon(),
          buildNotificationIcon(),
        ],
      ),
    );
  }
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

Widget buildTextField1(TextEditingController controller, List _placesList) {
   int itemCount = _placesList.length;
  double itemHeight = 50.0; // Height of each item
  return SizedBox(
    //height: _placesList.length < 1 ? 350 : 350,
    child: Column(
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
                      blurRadius: 10)
                ],
                borderRadius: BorderRadius.circular(8)),
            child: TextFormField(
              controller: controller,
              //readOnly: true,
              /* onTap: () async{
                
              },*/
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffA7A7A7)),
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
                  border: InputBorder.none),
            ),
          ),
        ),
        SizedBox(
            height: itemCount * itemHeight,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _placesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      List<Location> locations = await locationFromAddress(
                          _placesList[index]['description']);
                      print(locations.last.longitude);
                      print(locations.last.latitude);
                    },
                    title: Text(_placesList[index]['description']),
                  );
                }))
      ],
    ),
  );
}

Widget buildTextField(TextEditingController controller, List _placesList) {
  return SizedBox(
    height: 300,
    child: Column(
      children: [
        SizedBox(
          height: 100,
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search for a destination',
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
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
          ),
        ),
        Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _placesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      List<Location> locations = await locationFromAddress(
                          _placesList[index]['description']);
                      print(locations.last.longitude);
                      print(locations.last.latitude);
                    },
                    title: Text(_placesList[index]['description']),
                  );
                }))
      ],
    ),
  );
}

Widget buildCurrentLocationIcon() {
  return const Align(
    alignment: Alignment.bottomRight,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 40, right: 70),
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
