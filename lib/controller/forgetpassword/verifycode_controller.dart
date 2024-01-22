import 'dart:ffi';

import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/constant/routes.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/data/datasource/remote/forgetpassword/verifycode.dart';
import 'package:ecommercebig/view/screen/auth/forgetpassword/verifycode.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

abstract class VerifyCodeController extends GetxController {
  checkCode();
  goToResetPassword(String verifycode);
}

class VerifyCodeControllerImp extends VerifyCodeController {
  String? email;
  verifycodeforgetpassworddata verifycodeforget =
      verifycodeforgetpassworddata(Get.find());
  statusrequest? statusreq = statusrequest.none;

  @override
  checkCode() {}

  @override
  goToResetPassword(verifycode) async {
    statusreq = statusrequest.loading;
    update();
    var response = await verifycodeforget.postdata(verifycode, email!);
    print("============================ Controller $response");
    statusreq = handlingdata(response);

    if (statusrequest.success == statusreq) {
      if (response['status'] == "Success") {
        Get.offNamed(AppRoute.resetPassword, arguments: {"email": email});
      } else {
        Get.defaultDialog(
            title: "Warning", middleText: "Please Enter Valid Verify Code");
        statusreq = statusrequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    email = Get.arguments['email'];
    super.onInit();
  }
}
