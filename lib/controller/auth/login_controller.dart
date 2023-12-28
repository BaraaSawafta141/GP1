import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/constant/routes.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/core/middleware/mymiddleware.dart';
import 'package:ecommercebig/core/services/services.dart';
import 'package:ecommercebig/data/datasource/remote/auth/login.dart';
import 'package:ecommercebig/data/datasource/remote/payment/card.dart';
import 'package:ecommercebig/view/screen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

MyServices userServices = Get.find();

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
  List data = [];
  statusrequest statusreq = statusrequest.none;

  showPassword() {
    isshowpassword = isshowpassword == true ? false : true;
    update();
  }

  @override
  login() async {
    if (formstate.currentState!.validate()) {
      //statusreq = statusrequest.loading;
      //update();
      var response = await loginData.postdata(password.text, email.text);
      print("============================ Controller $response ");
      statusreq = handlingdata(response);

      if (statusrequest.success == statusreq) {
        if (response['status'] == "Success") {
          //data.addAll(response['data']);
          myServices.sharedPreferences.setString("Login", "1");
          userServices.sharedPreferences
              .setString("id", response['message']['users_id'].toString());
          userServices.sharedPreferences
              .setString("email", response['message']['users_email']);
          userServices.sharedPreferences
              .setString("name", response['message']['users_name']);
          userServices.sharedPreferences
              .setString("phone", response['message']['users_phone']);
          userServices.sharedPreferences.setString("password", password.text);
          userServices.sharedPreferences
              .setString("image", response['message']['users_photo']);
          update();
          Get.off(home());
          //Get.offNamed(AppRoute.homepage);
        } else {
          AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: 'Warning',
            desc: 'Email Or Password Not Correct',
            //btnCancelOnPress: () {},
            btnOkOnPress: () {},
          ).show();
          // Get.defaultDialog(
          //     title: "Warning", middleText: "Email Or Password Not Correct");
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
