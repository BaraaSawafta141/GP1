import 'package:ecommercebig/core/constant/routes.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/data/datasource/remote/auth/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';

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
      print("============================ Controller $response ");
      statusreq = handlingdata(response);

      if (statusrequest.success == statusreq) {
        if (response['success'] == "success") {
          //data.addAll(response['data']);
          Get.offNamed(AppRoute.verfiyCodeSignUp,arguments: {"email":email.text});
        } else {
          Get.defaultDialog(
              title: "Warning",
              middleText: "Phone Number Or Email Already Exist");
          statusreq = statusrequest.failure;
        }
      }
      update();
    } else {}
  }

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
