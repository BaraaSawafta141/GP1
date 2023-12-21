import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommercebig/data/datasource/remote/ride_history.dart';
import 'package:ecommercebig/view/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/core/services/services.dart';

MyServices myServices = Get.find();
statusrequest statusreq = statusrequest.none;
rideHistorydata ridehistory = rideHistorydata(Get.find());

class rideHistory extends StatelessWidget {
  const rideHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
saveRideHistory(String source, String destination) async {
  // Assuming you have a method in your services for saving ride history
  var response = await ridehistory.postdata(source, destination);

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

class rideHistorytemp extends StatelessWidget {
  rideHistorytemp({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            //leading: Icon(Icons.album),
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),

        ],
      ),
    );
  }
}
