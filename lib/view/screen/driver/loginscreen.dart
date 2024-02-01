import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/core/middleware/mymiddleware.dart';
import 'package:ecommercebig/data/datasource/remote/driver/auth/driverLogin.dart';
import 'package:ecommercebig/data/datasource/remote/driver/check_driver.dart';
import 'package:ecommercebig/data/datasource/remote/driver/reserveDriver.dart';
import 'package:ecommercebig/view/screen/driver/carinforegister/pages/uploaddocument.dart';
import 'package:ecommercebig/view/screen/driver/driverhome.dart';
import 'package:ecommercebig/view/screen/driver/driverloginphone.dart';
import 'package:ecommercebig/view/screen/driver/driverprofile.dart';
import 'package:ecommercebig/view/screen/driver/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommercebig/core/services/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

late TextEditingController passwordController = TextEditingController();
late TextEditingController phoneNumController = TextEditingController();
reserveDriverData BecomeNotAvailable =
    reserveDriverData(Get.find()); //become not available
String? verify;
String? phonenum;
FirebaseAuth auth = FirebaseAuth.instance;
driverLogin check = driverLogin(Get.find());
statusrequest statusreq = statusrequest.none;
MyServices driverServices = Get.find();

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
        print(">>>>>>>>>>>>>>>>>>> the sms code is $smsCode");
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
    verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
      print("=================code correct================");
    },
    verificationFailed: (FirebaseAuthException error) {
      print("=================code not correct================");
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      print("=================code TimedOut ================");
    },
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

CountryCode countryCode =
    CountryCode(name: 'Palestine', code: "PS", dialCode: "+970");

class _LoginScreenState extends State<LoginScreen> {
  @override
  final countryPicker = const FlCountryCodePicker();

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
              }, passwordController, phoneNumController),
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
      height: Get.height * 0.4,
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

onSubmit(String? input, String password) async {
  phonenum = input!;
  var response = await check.postdata(phonenum!, password);
  statusreq = handlingdata(response);
  passwordController.clear();
  phoneNumController.clear();
  if (statusrequest.success == statusreq) {
    if (response['status'] == "Success") {
     await BecomeNotAvailable.postdata(response['message']['drivers_id'].toString());
      driverServices.sharedPreferences
          .setString("id", response['message']['drivers_id'].toString());
      driverServices.sharedPreferences
          .setString("name", response['message']['drivers_name']);
      driverServices.sharedPreferences
          .setString("email", response['message']['drivers_email']);
      driverServices.sharedPreferences
          .setString("img", response['message']['drivers_photo']);
      // myServices.sharedPreferences.setString("homedriver", "1");
      if (response['message']['drivers_adminApprove'] == 0) {
        myServices.sharedPreferences.setString("DocumentUploadedPage", "1");
        Get.off(() => DocumentUploadedPage());
      } else {
        print('========this is a old number====================');
        Get.offAll(() => homedriver());
      }
    } else {
      if (response['status'] == "failure") {
        if (response['message'] == "email or password") {
          Get.snackbar("Error", "Phone or password is wrong");
        } else {
          // never used
          print(
              "========This is phoneNum============$phonenum====================");
          Get.off(() => DriverProfileSetup());
        }
      }
    }
  }
}
