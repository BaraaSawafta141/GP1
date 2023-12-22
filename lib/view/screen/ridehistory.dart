import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/view/widget/ride_history/ride_history.dart';
import 'package:ecommercebig/view/screen/home.dart';
import 'package:ecommercebig/view/widget/ride_history/customCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/core/services/services.dart';

MyServices myServices = Get.find();
statusrequest statusreq = statusrequest.none;
rideHistorydata ridehistory = rideHistorydata(Get.find());

crud Crud = crud();
rideHistorydata ridesData = rideHistorydata(Get.find());

class rideHistory extends StatelessWidget {
  const rideHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ride History'),
          leading: InkWell(
              onTap: () {
                Get.to(home());
              },
              child: Icon(Icons.arrow_back)),
        ),
        body: rideHistorytemp(),
      ),
    );
  }
}

@override
saveRideHistory(String source, String destination, String currentTime) async {
  // Assuming you have a method in your services for saving ride history
  var response = await ridehistory.postdata(source, destination, currentTime);

  statusreq = handlingdata(response);

  if (statusrequest.success == statusreq) {
    if (response['status'] == "success") {
      // Handle success, e.g., show a success dialog
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Success',
        desc: 'Ride history saved successfully',
        //btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } else {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Error in saving ride history',
        //btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    }
  }
  setState() {}
  ;
}

getRides() async {
  var response = await ridesData.getdata();
  statusreq = handlingdata(response);

  if (statusrequest.success == statusreq) {
    if (response['status'] == "success") {
      return response['data'];
    } else {
      return AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Warning',
        desc: 'error in getting ride history',
        //btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    }
  }
}

class rideHistorytemp extends StatelessWidget {
  rideHistorytemp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data.length == 0){
              return const Center(child: Text("No rides yet"));
            }
            return ListView.builder(
              // itemCount: 3,
              itemCount: snapshot.data.length,
              shrinkWrap: true, 
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return CardRideHistory(
                  source: snapshot.data[index]['ride_history_src'],
                  destination: snapshot.data[index]['ride_history_dst'],
                  time: snapshot.data[index]['ride_history_time'],
                );
              },
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: CircularProgressIndicator());
        },
        future: getRides(),
      ),
    );
  }
}
