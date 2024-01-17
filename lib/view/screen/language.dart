
import 'package:ecommercebig/core/constant/routes.dart';
import 'package:ecommercebig/core/localization/changelocal.dart';
import 'package:ecommercebig/view/widget/language/custombuttomlang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart'; 

class Language extends GetView<LocaleController> {
  const Language({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie/lang.json'),
              // Image.asset("assets/images/lang.png"),
              Text("1".tr, style: Theme.of(context).textTheme.headline1),
              const SizedBox(height: 20),
              CustomButtonLang(
                  textbutton: "42".tr,
                  onPressed: () {
                    controller.changeLang("ar");
                    Get.toNamed(AppRoute.onBoarding) ; 
                  },
                  
                  ),
              CustomButtonLang(
                  textbutton: "43".tr,
                  onPressed: () {
                    controller.changeLang("en");
                    Get.toNamed(AppRoute.onBoarding) ; 
                  }),
            ],
          )),
    );
  }
}
