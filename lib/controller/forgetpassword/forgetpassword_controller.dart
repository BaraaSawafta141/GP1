import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/constant/routes.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/data/datasource/remote/forgetpassword/checkemail.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

abstract class ForgetPasswordController extends GetxController {
  checkemail();
}

class ForgetPasswordControllerImp extends ForgetPasswordController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController email;
  checkemaildata checkEmailData = checkemaildata(Get.find());
  statusrequest? statusreq = statusrequest.none;
  @override
  checkemail() async {
    if (formstate.currentState!.validate()) {
      statusreq = statusrequest.loading;
      update();
      var response = await checkEmailData.postdata(email.text);
      print("============================ Controller $response ");
      statusreq = handlingdata(response);

      if (statusrequest.success == statusreq) {
        if (response['status'] == "Success") {
          //data.addAll(response['data']);
          Get.offNamed(AppRoute.verfiyCode, arguments: {"email": email.text});
        } else {
          Get.defaultDialog(
              title: "Warning", middleText: "Email Not Found");
          statusreq = statusrequest.failure;
        }
      }
      update();
    }
  }



  @override
  void onInit() {
    email = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }
}
