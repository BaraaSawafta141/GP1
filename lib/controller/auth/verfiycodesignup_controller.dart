import 'package:ecommercebig/core/class/statusrequest.dart';

import 'package:ecommercebig/core/constant/routes.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/data/datasource/remote/auth/verifycodesignup.dart';
import 'package:get/get.dart';

abstract class VerifyCodeSignUpController extends GetxController {
  checkCode();
  goToSuccessSignUp(String verifycodesignup);
}

class VerifyCodeSignUpControllerImp extends VerifyCodeSignUpController {
  //late String verifycode;
  String? email;
  verifycodesignup verifycodesign = verifycodesignup(Get.find());
  statusrequest statusreq = statusrequest.none;
  @override
  checkCode() {}

  @override
  goToSuccessSignUp(String verifycodesignup) async {
    statusreq = statusrequest.loading;
    update();
    var response = await verifycodesign.postdata(email!, verifycodesignup);
    print("============================ Controller $response ");
    statusreq = handlingdata(response);

    if (statusrequest.success == statusreq) {
      if (response['success'] == "success") {
        Get.offNamed(AppRoute.successSignUp);
      } else {
        Get.defaultDialog(
            title: "Warning",
            middleText: "Please Enter Valid Verify Code");
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
