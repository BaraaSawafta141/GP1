import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/constant/routes.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/data/datasource/remote/auth/signup.dart';
import 'package:ecommercebig/view/screen/auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

abstract class SignUpController extends GetxController {
  signUp();
  goToSignIn();
}

class SignUpControllerImp extends SignUpController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController password;

  statusrequest statusreq = statusrequest.none;
  signupdata testdata = signupdata(Get.find());

  List data = [];

  @override
  signUp() async {
    if (formstate.currentState!.validate()) {
      statusreq = statusrequest.loading;
      update();
      var response = await testdata.postdata(
          username.text, password.text, email.text, phone.text);
      //print("============================ Controller $response ");
      statusreq = handlingdata(response);
      if (statusrequest.success == statusreq) {
        if (response['status'] == "success") {
          // data.addAll(response['data']);
          Get.offNamed(AppRoute.verfiyCodeSignUp,
              arguments: {"email": email.text});
        } else {
          AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: 'Warning',
            desc: 'Phone Number Or Email Already Exist',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          ).show();
          // Get.defaultDialog(
          //     title: "Warning",
          //     middleText: "Phone Number Or Email Already Exist");
          statusreq = statusrequest.failure;
        }
      }
      update();
    } else {}
  }
  /*signUp() async {
    if (formstate.currentState!.validate()) {
      var response = await testdata.postdata(
          username.text, password.text, email.text, phone.text);
      var parsedResponse = handlingdata(response);

      if (parsedResponse is Map<String, dynamic>) {
        final Map<String, dynamic> responseData = parsedResponse;

        if (responseData.containsKey("status") &&
            responseData["status"] == "success") {
          // Show success dialog and navigate to Login screen
          Get.defaultDialog(
            title: "Success",
            middleText: "Account created successfully",
            onConfirm: () {
              Get.to(Login());
            },
          );
        } else {
          // Check if the error is due to existing email or phone
          if (responseData.containsKey("message") &&
              (responseData["message"] == "Email already exists" ||
                  responseData["message"] == "Phone already exists")) {
            Get.defaultDialog(
              title: "Warning",
              middleText: "Email or Phone Number Already Exist",
            );
          } else {
            Get.defaultDialog(
              title: "Warning",
              middleText: "Registration Failed",
            );
          }
          statusreq = statusrequest.failure;
        }
      } else if (parsedResponse is statusrequest) {
        // Handle the case where handlingdata returned a statusrequest
        // For example, you might update the UI or take specific actions
        Get.defaultDialog(
          title: "Success",
          content: Text("Account created successfully"),
        );
        Get.to(Login());
        print("Handling data returned status: $parsedResponse");
      }
      update();
    } else {
      // Handle form validation failure if needed
    }
  }*/

  @override
  goToSignIn() {
    Get.offNamed(AppRoute.login);
  }

  @override
  void onInit() {
    username = TextEditingController();
    phone = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
  }
}
