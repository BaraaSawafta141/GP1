import 'package:ecommercebig/core/middleware/mymiddleware.dart';
import 'package:ecommercebig/data/datasource/remote/driver/check_approval.dart';
import 'package:ecommercebig/view/screen/driver/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DocumentUploadedPage extends StatefulWidget {
  // const DocumentUploadedPage(String s, {Key? key}) : super(key: key);
  @override
  State<DocumentUploadedPage> createState() => _DocumentUploadedPageState();
}

checkApproval checkapproval = checkApproval(Get.find());

class _DocumentUploadedPageState extends State<DocumentUploadedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
          title: Text(
            "Car Registration",
            textAlign: TextAlign.center,
          ),
        ),
        // appBar: AppBar(
        //   //leading: Icon(Icons.arrow_back),
        //   backgroundColor: Colors.green,
        //   title: Text(
        //     "Car Registration",
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              textIntroForPages(
                  title: 'Car Registration',
                  subtitle: 'Waiting for approval from admin'),
              SizedBox(
                height: 30,
              ),
              Container(
                width: Get.width,
                height: Get.height * 0.1,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffE3E3E3).withOpacity(0.4),
                    border: Border.all(
                        color: Color(0xff2FB654).withOpacity(0.26), width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: 40,
                      color: Color(0xff7D7D7D),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Vehicle Registration',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        Text(
                          'Waiting For Approval',
                          style:
                              TextStyle(fontSize: 16, color: Color(0xff62B62F)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () async {
                  // print("widget :" + widget.key.toString());
                  var res = await checkapproval.postdata(
                      driverServices.sharedPreferences.getString("id")!);
                  if (res['status'] == "Success") {
                    myServices.sharedPreferences
                        .setString("DocumentUploadedPage", "0");
                    myServices.sharedPreferences.setString("homedriver", "1");
                    Get.offAllNamed("/driverhome");
                  } else {
                    Get.snackbar("Error", "You are not approved yet!");
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff2FB654)),
                  child: Center(
                    child: Text(
                      'Check Approval',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget textIntroForPages(
      {String title = "Profile Settings", String? subtitle}) {
    return Container(
      //color: Colors.green[150],
      width: Get.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            //blurStyle: BlurStyle.,
            color: Colors.green.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 17,
            offset: Offset(0, 3),
          ),
        ],
        /*image: DecorationImage(
            image: AssetImage('assets/images/mask.png'),
            fit: BoxFit.fill
        )*/
      ),
      height: Get.height * 0.3,
      child: Container(
          height: Get.height * 0.1,
          width: Get.width,
          margin: EdgeInsets.only(bottom: Get.height * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.green),
                ),
            ],
          )),
    );
  }
}
