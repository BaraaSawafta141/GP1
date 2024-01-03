import 'package:ecommercebig/view/screen/driver/driverprofile.dart';
import 'package:ecommercebig/view/screen/driver/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pinput/pinput.dart';

class RoundedWithShadow extends StatefulWidget {
  @override
  _RoundedWithShadowState createState() => _RoundedWithShadowState();
}

final controllerpinput = TextEditingController();

class _RoundedWithShadowState extends State<RoundedWithShadow> {
  final focusNode = FocusNode();

  // AuthController authController = Get.find<AuthController>();
  

  @override
  void dispose() {
    controllerpinput.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: GoogleFonts.poppins(
          fontSize: 20, color: Color.fromRGBO(70, 69, 66, 1)),
      decoration: BoxDecoration(
        color: Color.fromRGBO(232, 235, 241, 0.37),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return Pinput(
      length: 6,
      controller: controllerpinput,
      focusNode: focusNode,
      onCompleted: (String input) {
        codeSent();
        // authController.isDecided = false;
        // authController.verifyOtp(input);
        // // what i want to do after enter the otp code
        // print("==================${controller.text}===================");
        // Get.to(DriverProfileSetup());
      },
      defaultPinTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(211, 149, 149, 0.059),
              offset: Offset(0, 3),
              blurRadius: 16,
            )
          ],
        ),
      ),
      //separator: SizedBox(width: 10),
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
              offset: Offset(0, 3),
              blurRadius: 16,
            )
          ],
        ),
      ),
      showCursor: true,
      cursor: cursor,
    );
  }
}
