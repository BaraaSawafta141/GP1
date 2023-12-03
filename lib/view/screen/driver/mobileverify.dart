import 'package:ecommercebig/view/screen/driver/constants.dart';
import 'package:ecommercebig/view/screen/driver/loginscreen.dart';
import 'package:ecommercebig/view/screen/driver/pinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpVerificationScreen extends StatefulWidget {
  String phoneNumber;
  OtpVerificationScreen(this.phoneNumber);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  //AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    // TODO: implement initState
    phoneverify();
    super.initState();
    //authController.phoneAuth(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                greenIntroWidget(),
                Positioned(
                  top: 60,
                  left: 30,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            otpVerificationWidget(),
            ElevatedButton(
                onPressed: () {
                  codeSent();
                },
                child: Text("confirm"))
          ],
        ),
      ),
    );
  }

  Widget otpVerificationWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(text: AppConstants.phoneVerification),
          textWidget(
              text: AppConstants.enterOtp,
              fontSize: 22,
              fontWeight: FontWeight.bold),
          const SizedBox(
            height: 40,
          ),
          Container(width: Get.width, height: 50, child: RoundedWithShadow()),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
                  children: [
                    TextSpan(
                      text: AppConstants.resendCode + " ",
                    ),
                    TextSpan(
                        text: "10 seconds",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ]),
            ),
          )
        ],
      ),
    );
  }

  Widget textWidget(
      {required String text,
      double fontSize = 12,
      FontWeight fontWeight = FontWeight.normal,
      Color color = Colors.black}) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          fontSize: fontSize, fontWeight: fontWeight, color: color),
    );
  }

  Widget greenIntroWidget() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/mask.png'), fit: BoxFit.cover)),
      height: Get.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Driver Verification",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          //SvgPicture.asset('assets/images/leaf.svg'),

          const SizedBox(
            height: 20,
          ),

          //SvgPicture.asset('assets/images/taxi.svg')
        ],
      ),
    );
  }
}
