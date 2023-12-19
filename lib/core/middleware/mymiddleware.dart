
import 'package:ecommercebig/core/constant/routes.dart';
import 'package:ecommercebig/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyMiddleWare extends GetMiddleware {
  @override
  int? get priority => 1;

  MyServices myServices = Get.find() ; 

  @override
  RouteSettings? redirect(String? route) {
     if(myServices.sharedPreferences.getString("onboarding") == "1"){
      return const RouteSettings(name: AppRoute.login) ; 
     }
     if(myServices.sharedPreferences.getString("Login") == "1"){
      return const RouteSettings(name: AppRoute.homepage) ; 
     }
  }
}
