import 'package:ecommercebig/view/screen/driver/constants.dart';
import 'package:ecommercebig/view/screen/driver/driverprofile.dart';
import 'package:ecommercebig/view/screen/driver/loginscreen.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget loginWidget(
    CountryCode countryCode,
    Function onCountryChange,
    TextEditingController passwordController,
    TextEditingController phoneNumController) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: AppConstants.helloNiceToMeetYou),
        textWidget(
            text: AppConstants.getMovingWithGreenTaxi,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        const SizedBox(
          height: 40,
        ),
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 3,
                    blurRadius: 3)
              ],
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => onCountryChange(),
                    child: Container(
                      child: Row(
                        children: [
                          const SizedBox(width: 5),

                          Expanded(
                            child: Container(
                              child: countryCode.flagImage(),
                            ),
                          ),

                          textWidget(text: countryCode.dialCode),

                          // const SizedBox(width: 10,),

                          Icon(Icons.keyboard_arrow_down_rounded)
                        ],
                      ),
                    ),
                  )),
              Container(
                width: 1,
                height: 55,
                color: Colors.black.withOpacity(0.2),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: phoneNumController,
                    // onSubmitted: (String? input) => onSubmit(input, passwordController.text),
                    decoration: InputDecoration(
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.normal),
                        hintText: AppConstants.enterMobileNumber,
                        border: InputBorder.none),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 3,
                blurRadius: 3,
              )
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: passwordController,
              obscureText: true, // Password should be obscured
              decoration: InputDecoration(
                hintStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
                hintText: 'Enter Password', // Set your own hint text
                border: InputBorder.none,
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Add a button for logging in
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // You can handle the login action here
                String? phoneNumber = countryCode.dialCode +
                    phoneNumController
                        .text; // Get the phone number from your existing logic
                print(phoneNumber);
                String password = passwordController.text; // Get the password
                print(password);
                // Call the login function with phone number and password
                onSubmit(phoneNumber, password);
              },
              child: Text('Log In'),
            ),
            InkWell(
              child: Text('Don\'t have an account?'),
              onTap: () {
                Get.to(() => DriverProfileSetup());
              },
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
                children: [
                  TextSpan(
                    text: AppConstants.byCreating + " ",
                  ),
                  TextSpan(
                      text: AppConstants.termsOfService + " ",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: "and ",
                  ),
                  TextSpan(
                      text: AppConstants.privacyPolicy + " ",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
