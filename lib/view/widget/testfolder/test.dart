import 'dart:async';

import 'package:ecommercebig/view/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class testfile extends StatefulWidget {
  const testfile({super.key});

  @override
  State<testfile> createState() => _nameState();
}

String? mapTheme;

class _nameState extends State<testfile> {
  final Completer<GoogleMapController> _controller = Completer();
  static CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(32.223295060141346, 35.237885713381246), zoom: 15);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DefaultAssetBundle.of(context)
        .loadString('assets/maptheme/night.json')
        .then((value) {
      mapTheme = value;
    });
  }

  void updateMapStyle(String mapTheme) {
    _controller.future.then((value) {
      DefaultAssetBundle.of(context).loadString(mapTheme).then((string) {
        value.setMapStyle(string);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("map style"),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                        onTap: (() {
                          _controller.future.then((value) {
                            DefaultAssetBundle.of(context)
                                .loadString('assets/maptheme/silver.json')
                                .then((string) {
                              value.setMapStyle(string);
                            });
                          });
                        }),
                        child: Text("Silver")),
                    PopupMenuItem(
                        onTap: (() {
                          _controller.future.then((value) {
                            DefaultAssetBundle.of(context)
                                .loadString('assets/maptheme/retro.json')
                                .then((string) {
                              value.setMapStyle(string);
                            });
                          });
                        }),
                        child: Text("Retro")),
                    PopupMenuItem(
                        onTap: (() {
                          _controller.future.then((value) {
                            DefaultAssetBundle.of(context)
                                .loadString('assets/maptheme/night.json')
                                .then((string) {
                              value.setMapStyle(string);
                            });
                          });
                        }),
                        child: Text("Night")),
                  ])
        ],
      ),
      body: SafeArea(
        child: GoogleMap(
            initialCameraPosition: _kGooglePlex,
            //mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(mapTheme);
              _controller.complete(controller);
            }),
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
                      mymapcontroller?.setMapStyle(mapTheme);
                      updateMapStyle('assets/maptheme/silver.json');
                      Get.to(home());
                    },
                  ),
                  ListTile(
                    title: Text('Retro'),
                    onTap: () {
                      mymapcontroller?.setMapStyle(mapTheme);
                      updateMapStyle('assets/maptheme/retro.json');
                      Get.to(home());
                    },
                  ),
                  ListTile(
                    title: Text('Night'),
                    onTap: () {
                      updateMapStyle('assets/maptheme/night.json');
                      Get.to(home());
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
