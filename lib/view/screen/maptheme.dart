import 'dart:async';
import 'package:ecommercebig/view/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class maptheme extends StatefulWidget {
  const maptheme({
    Key? key,
  }) : super(key: key);

  @override
  State<maptheme> createState() => _nameState();
}

String? mapTheme = "assets/maptheme/night.txt";

class _nameState extends State<maptheme> {
  final Completer<GoogleMapController> _controller = Completer();
  static CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(32.223295060141346, 35.237885713381246), zoom: 15);

  @override
  void initState() {
    super.initState();
    // updateMapStyle(mapTheme!);

    rootBundle.loadString('assets/maptheme/night.txt').then((string) {
      mapTheme = string;
    });
  }

  // void updateMapStyle(String mapTheme) {
  //   _controller.future.then((value) {
  //     DefaultAssetBundle.of(context).loadString(mapTheme).then((string) {
  //       value.setMapStyle(string);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            mymapcontroller = (controller);
            mymapcontroller?.setMapStyle(mapTheme);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Silver'),
                    onTap: () {
                      _controller.future.then((value) {
                        rootBundle
                            .loadString('assets/maptheme/silver.txt')
                            .then((string) {
                          value.setMapStyle(string);
                        });
                      });
                      Get.back();
                    },
                  ),
                  ListTile(
                    title: Text('Retro'),
                    onTap: () {
                      _controller.future.then((value) {
                        rootBundle
                            .loadString('assets/maptheme/retro.txt')
                            .then((string) {
                          value.setMapStyle(string);
                        });
                      });
                      Get.back();
                    },
                  ),
                  ListTile(
                    title: Text('Night'),
                    onTap: () {
                      _controller.future.then((value) {
                        rootBundle
                            .loadString('assets/maptheme/night.txt')
                            .then((string) {
                          value.setMapStyle(string);
                        });
                      });
                      Get.back();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.style),
      ),
    );
  }
}
