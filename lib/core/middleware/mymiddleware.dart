import 'package:ecommercebig/core/constant/routes.dart';
import 'package:ecommercebig/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

MyServices myServices = Get.find();

class MyMiddleWare extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (myServices.sharedPreferences.getString("Login") == "1") {
      return const RouteSettings(name: AppRoute.homepage);
    }
    if (myServices.sharedPreferences.getString("onboarding") == "1") {
      return const RouteSettings(name: AppRoute.login);
    }
  }
}
