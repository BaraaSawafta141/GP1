import 'package:ecommercebig/controller/onboarding_controller.dart';
import 'package:ecommercebig/core/constant/color.dart';
import 'package:ecommercebig/core/constant/imageasset.dart';
import 'package:ecommercebig/data/datasource/static/static.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CustomSliderOnBoarding extends GetView<OnBoardingControllerImp> {
  const CustomSliderOnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: controller.pageController,
        onPageChanged: (val) {
          controller.onPageChanged(val);
        },
        itemCount: onBoardingList.length,
        itemBuilder: (context, i) => Column(
              children: [
                
                Image.asset(
                  onBoardingList[i].image!,
                  // width: ,
                  height: Get.width / 1.3,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 60),
                Text(onBoardingList[i].title!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: AppColor.black)),
                const SizedBox(height: 20),
                Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      onBoardingList[i].body!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          height: 2,
                          color: Color.fromARGB(255, 104, 103, 103),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )),
              ],
            ));
  }
}
