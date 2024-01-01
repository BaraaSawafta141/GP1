import 'dart:async';
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;

class customButtonSource extends StatefulWidget {
  const customButtonSource({super.key});

  @override
  State<customButtonSource> createState() => _nameState();
}

class _nameState extends State<customButtonSource> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    sourceController.addListener(() {
      onChangeSource();
    });
  }

  void onChangeSource() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
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

  var uuid = Uuid();
  String _sessionToken = '122344';
  TextEditingController destinationController = TextEditingController();
  GoogleMapController? mymapcontroller;

  List<dynamic> sourcePlacesList = [];
  bool isBottomSheetOpen = false;
  TextEditingController sourceController = TextEditingController();
  final Completer<GoogleMapController> _controllergoogle =
      Completer<GoogleMapController>();
  late LatLng destination;
  late LatLng source;
  Set<Marker> marks = Set<Marker>();

  double? srclong;
  double? srclati;
  @override
  Widget build(BuildContext context) {
    return custombuttondestination(mymapcontroller);
  }

  Widget custombuttondestination(mymapcontroller) {
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
}
