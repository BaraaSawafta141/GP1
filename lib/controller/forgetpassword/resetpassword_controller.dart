import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/constant/routes.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/data/datasource/remote/forgetpassword/resetpassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

abstract class ResetPasswordController extends GetxController {
  resetpassword();
  goToSuccessResetPassword();
}

class ResetPasswordControllerImp extends ResetPasswordController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  statusrequest? statusreq = statusrequest.none;
  late TextEditingController password;
  late TextEditingController repassword;
  resetpassworddata resetPasswordData = resetpassworddata(Get.find());
  String? email;
  @override
  resetpassword() {}

  @override
  goToSuccessResetPassword() async {
    if (password.text != repassword.text){
      return Get.defaultDialog(
          title: "Warning", middleText: "Passwords Doesn't Match");
    }
    if (formstate.currentState!.validate()) {
      statusreq = statusrequest.loading;
      update();
      var response = await resetPasswordData.postdata(password.text, email!);
      print("============================ Controller $response ");
      statusreq = handlingdata(response);

      if (statusrequest.success == statusreq) {
        if (response['status'] == "success") {
          //data.addAll(response['data']);
          Get.offNamed(AppRoute.successResetpassword);
        } else {
          Get.defaultDialog(
              title: "Warning", middleText: "Try Again");
          statusreq = statusrequest.failure;
        }
      }
      update();
    } else {
      print("Not Valid");
    }
  }

  @override
  void onInit() {
    email = Get.arguments['email'];
    password = TextEditingController();
    repassword = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    password.dispose();
    repassword.dispose();
    super.dispose();
  }
}
