import 'package:ecommercebig/main.dart';
import 'package:ecommercebig/view/screen/driver/driverloginphone.dart';
import 'package:ecommercebig/view/screen/driver/driverprofile.dart';
import 'package:ecommercebig/view/screen/driver/mobileverify.dart';
import 'package:ecommercebig/view/screen/driver/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

String? verify;
String? phonenum;
FirebaseAuth auth = FirebaseAuth.instance;
void phoneauth() async {
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phonenum,
    verificationCompleted: (PhoneAuthCredential credential) {},
    verificationFailed: (FirebaseAuthException e) {},
    codeSent: (String verificationId, int? resendToken) {
      verify = verificationId;
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}

void verificationcompleted() async {
  await auth.verifyPhoneNumber(
    phoneNumber: phonenum,
    verificationCompleted: (PhoneAuthCredential credential) async {
      // ANDROID ONLY!

      // Sign the user in (or link) with the auto-generated credential
      await auth.signInWithCredential(credential);

      Get.to(DriverProfileSetup());
    },
    verificationFailed: (FirebaseAuthException error) {},
    codeSent: (String verificationId, int? forceResendingToken) {},
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}

void verificationFailed() async {
  await auth.verifyPhoneNumber(
    phoneNumber: phonenum,
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }

      // Handle other errors
    },
    verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
    codeSent: (String verificationId, int? forceResendingToken) {},
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}

void codeSent() async {
  await auth.verifyPhoneNumber(
    phoneNumber: phonenum,
    codeSent: (String verificationId, int? resendToken) async {
      try {
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = controllerpinput as String;

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verify!, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential).then((value) {
          if (value.user != null) {
            Get.to(DriverProfileSetup());
          }
        });
      } catch (e) {
        print("=================code not correct================");
      }
    },
    verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
    verificationFailed: (FirebaseAuthException error) {},
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}

void codeAutoRetrievalTimeout() async {
  await auth.verifyPhoneNumber(
    phoneNumber: phonenum,
    //timeout: const Duration(seconds: 60),
    codeAutoRetrievalTimeout: (String verificationId) {
      // Auto-resolution timed out...
    },
    verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
    verificationFailed: (FirebaseAuthException error) {},
    codeSent: (String verificationId, int? forceResendingToken) {},
  );
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  final countryPicker = const FlCountryCodePicker();

  CountryCode countryCode =
      CountryCode(name: 'Palestine', code: "PS", dialCode: "+970");

  onSubmit(String? input) {
    Get.to(() => OtpVerificationScreen(countryCode.dialCode + input!));
    phonenum = countryCode.dialCode + input!;
    //print("====================${countryCode.dialCode + input!}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              greenIntroWidget(),
              const SizedBox(
                height: 50,
              ),
              loginWidget(countryCode, () async {
                final code = await countryPicker.showPicker(context: context);
                if (code != null) countryCode = code;
                setState(() {});
              }, onSubmit),
            ],
          ),
        ),
      ),
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
