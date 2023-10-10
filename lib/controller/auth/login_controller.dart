import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/constant/routes.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/data/datasource/remote/auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

abstract class LoginController extends GetxController {
  login();
  goToSignUp();
  goToForgetPassword();
}

class LoginControllerImp extends LoginController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  logindata loginData = logindata(Get.find());
  late TextEditingController email;
  late TextEditingController password;

  bool isshowpassword = true;

  statusrequest statusreq = statusrequest.none;

  showPassword() {
    isshowpassword = isshowpassword == true ? false : true;
    update();
  }

  @override
  login() async {
    if (formstate.currentState!.validate()) {
      statusreq = statusrequest.loading;
      update();
      var response = await loginData.postdata(password.text, email.text);
      print("============================ Controller $response ");
      statusreq = handlingdata(response);

      if (statusrequest.success == statusreq) {
        if (response['success'] == "success") {
          //data.addAll(response['data']);
          Get.offNamed(AppRoute.homepage, arguments: {"email": email.text});
        } else {
          Get.defaultDialog(
              title: "Warning", middleText: "Email Or Password Not Correct");
          statusreq = statusrequest.failure;
        }
      }
      update();
    } else {}
  }

  @override
  goToSignUp() {
    Get.offNamed(AppRoute.signUp);
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  goToForgetPassword() {
    Get.toNamed(AppRoute.forgetPassword);
  }
}
