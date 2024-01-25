import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommercebig/data/datasource/remote/driver/getCurrentReq.dart';
import 'package:ecommercebig/view/screen/driver/driverhome.dart';
import 'package:ecommercebig/view/widget/ride_history/driverCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:lottie/lottie.dart';

statusrequest statusreq = statusrequest.none;
getCurrentReq currentReq = getCurrentReq(Get.find());

class driverRequest extends StatelessWidget {
  const driverRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Current Ride'),
          leading: InkWell(
              onTap: () {
                Get.to(() => homedriver());
              },
              child: Icon(Icons.arrow_back)),
        ),
        body: driverRequesttemp(),
      ),
    );
  }
}

getRequest() async {
  var res = await currentReq.postdata(driverId);
  print(driverId);
  print("======================================");
  print(res);
  statusreq = handlingdata(res);
  if (statusrequest.success == statusreq) {
    if (res['status'] == "Success") {
      return res['message'];
    } else {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Error',
        desc: res['message'],
        btnOkOnPress: () {},
      ).show();
    }
  } else {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: 'Error',
      desc: "Error",
      btnOkOnPress: () {},
    ).show();
  }
}

class driverRequesttemp extends StatelessWidget {
  driverRequesttemp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return const Center(child: Text("No current ride"));
              }
              return CardDriver(
                source: snapshot.data['ride_history_src'],
                destination: snapshot.data['ride_history_dst'],
                phone: snapshot.data['phone'],
                Username: snapshot.data['name'],
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Lottie.asset('assets/lottie/load.json'));
            }
            return Center(
                child: Text("No current rides",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
          },
          future: getRequest(),
        ));
  }
}
