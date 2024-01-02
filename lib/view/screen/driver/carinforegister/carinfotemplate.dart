import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/middleware/mymiddleware.dart';
import 'package:ecommercebig/data/datasource/remote/driver/car_info.dart';
import 'package:ecommercebig/view/screen/driver/carinforegister/pages/location.dart';
import 'package:ecommercebig/view/screen/driver/carinforegister/pages/uploaddoc.dart';
import 'package:ecommercebig/view/screen/driver/carinforegister/pages/uploaddocument.dart';
import 'package:ecommercebig/view/screen/driver/carinforegister/pages/vehiclecolor.dart';
import 'package:ecommercebig/view/screen/driver/carinforegister/pages/vehicleplatenumber.dart';
import 'package:ecommercebig/view/screen/driver/carinforegister/pages/vehicletype.dart';
import 'package:ecommercebig/view/screen/driver/carinforegister/pages/vehicleyear.dart';
import 'package:ecommercebig/view/screen/driver/carinforegister/pages/vericletype.dart';
import 'package:ecommercebig/view/screen/driver/driverhome.dart';
import 'package:ecommercebig/view/screen/driver/driverprofile.dart';
import 'package:ecommercebig/view/screen/driver/driverupdateprofile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class carRegistertemplate extends StatefulWidget {
  const carRegistertemplate({super.key});

  @override
  State<carRegistertemplate> createState() => _nameState();
}

class _nameState extends State<carRegistertemplate> {
  PageController pageController = PageController();
  carInfoData carInfodata = carInfoData(Get.find());
  statusrequest statusreq = statusrequest.none;
  int currentpage = 0;
  String selectedLocations = '';
  String selectedVehicalType = '';
  String selectedVehicalMake = '';
  String selectModelYear = '';
  TextEditingController vehicalNumberController = TextEditingController();
  String vehicalColor = '';
  File? document;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.arrow_back),
        backgroundColor: Colors.green,
        title: Text(
          "Car Registration",
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          textIntroForPages(
              title: 'Car Registration',
              subtitle: 'Complete the process detail'),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
            ),
            child: PageView(
              onPageChanged: (int page) {
                currentpage = page;
              },
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                locationPage(
                  selectedLocations: selectedLocations,
                  onSelect: (String location) {
                    setState(() {
                      selectedLocations = location;
                    });
                  },
                ),
                VehicalTypePage(
                  selectedVehical: selectedVehicalType,
                  onSelect: (String vehicalType) {
                    setState(() {
                      selectedVehicalType = vehicalType;
                    });
                  },
                ),
                VehicalMakePage(
                  selectedVehical: selectedVehicalMake,
                  onSelect: (String vehicalMake) {
                    setState(() {
                      selectedVehicalMake = vehicalMake;
                    });
                  },
                ),
                VehicalModelYearPage(
                  onSelect: (int year) {
                    setState(() {
                      selectModelYear = year.toString();
                    });
                  },
                ),
                VehicalNumberPage(
                  controller: vehicalNumberController,
                ),
                VehicalColorPage(
                  onColorSelected: (String selectedColor) {
                    vehicalColor = selectedColor;
                  },
                ),
                UploadDocumentPage(
                  onImageSelected: (File image) {
                    document = image;
                  },
                ),
                // DocumentUploadedPage()
              ],
            ),
          )),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                      onPressed: () {
                        pageController.animateToPage(currentpage - 1,
                            duration: Duration(seconds: 1),
                            curve: Curves.easeIn);
                      },
                      heroTag: 'prevButton',
                      child: Text(
                        "Prev",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      backgroundColor: Colors.green,
                    )),
              ),
              SizedBox(
                width: 235,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () async {
                        pageController.animateToPage(currentpage + 1,
                            duration: Duration(seconds: 1),
                            curve: Curves.easeIn);

                        if (currentpage == 6) {
                          if (selectedLocations.isEmpty ||
                              selectedVehicalType.isEmail ||
                              selectedVehicalMake.isEmpty ||
                              selectModelYear.isEmpty ||
                              vehicalNumberController.text.isEmpty ||
                              vehicalColor.isEmpty ||
                              document == null) {
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: 'Error',
                                    desc: 'Please fill all the fields',
                                    // btnonCancel: () {
                                    //   //Get.back();
                                    // },
                                    showCloseIcon: true)
                                .show();
                          } else {
                            var response = await carInfodata.postdata(
                                selectedLocations,
                                selectedVehicalType,
                                selectedVehicalMake,
                                selectModelYear,
                                vehicalNumberController.text,
                                vehicalColor,
                                driverId!,
                                document!);

                            AwesomeDialog(
                              context: Get.context!,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: 'Car Registration',
                              desc:
                                  'Your request has been registered successfully',
                              btnOkOnPress: () {
                                myServices.sharedPreferences.setString("DocumentUploadedPage","1");
                                Get.off(() => homedriver());
                              },
                            ).show();
                          }

                          // We need to go to waiting for approval page
                          // Get.to( () =>DocumentUploadedPage() );
                        }
                      },
                      heroTag: 'nextButton',
                      child: Text(
                        "Next",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      backgroundColor: Colors.green,
                    )),
              ),
            ],
          )
        ],
      ),
    );
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
