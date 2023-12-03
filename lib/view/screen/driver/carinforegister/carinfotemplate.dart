import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class carRegistertemplate extends StatefulWidget {
  const carRegistertemplate({super.key});

  @override
  State<carRegistertemplate> createState() => _nameState();
}

class _nameState extends State<carRegistertemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
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
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Text(
                    "Next",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  backgroundColor: Colors.green,
                )),
          )
        ],
      ),
    );
  }

  Widget textIntroForPages(
      {String title = "Profile Settings", String? subtitle}) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
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
