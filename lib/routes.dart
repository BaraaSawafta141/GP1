import 'package:ecommercebig/core/constant/routes.dart';
import 'package:ecommercebig/core/functions/checkconnectivity.dart';
import 'package:ecommercebig/core/middleware/mymiddleware.dart';
import 'package:ecommercebig/main.dart';
import 'package:ecommercebig/view/widget/testfolder/test.dart';
import 'package:ecommercebig/test_view.dart';
import 'package:ecommercebig/view/screen/auth/forgetpassword/forgetpassword.dart';
import 'package:ecommercebig/view/screen/auth/forgetpassword/resetpassword.dart';
import 'package:ecommercebig/view/screen/auth/forgetpassword/success_resetpassword.dart';
import 'package:ecommercebig/view/screen/auth/forgetpassword/verifycode.dart';
import 'package:ecommercebig/view/screen/auth/login.dart';
import 'package:ecommercebig/view/screen/auth/signup.dart';
import 'package:ecommercebig/view/screen/auth/success_signup.dart';
import 'package:ecommercebig/view/screen/auth/verifycodesignup.dart';
import 'package:ecommercebig/view/screen/home.dart';
import 'package:ecommercebig/view/screen/language.dart';
import 'package:ecommercebig/view/screen/myprofile.dart';
import 'package:ecommercebig/view/screen/onboarding.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>>? routes = [
  //GetPage(name: "/", page: () => const Language() , middlewares: [
  //MyMiddleWare()
  //]),
  GetPage(name: "/", page: () => home()),
  //Auth
  GetPage(name: AppRoute.login, page: () => const Login()),
  GetPage(name: AppRoute.signUp, page: () => const SignUp()),
  GetPage(name: AppRoute.forgetPassword, page: () => const ForgetPassword()),
  GetPage(name: AppRoute.verfiyCode, page: () => const VerfiyCode()),
  GetPage(name: AppRoute.resetPassword, page: () => const ResetPassword()),
  GetPage(
      name: AppRoute.successResetpassword,
      page: () => const SuccessResetPassword()),
  GetPage(name: AppRoute.successSignUp, page: () => const SuccessSignUp()),
  GetPage(name: AppRoute.onBoarding, page: () => const OnBoarding()),
  GetPage(
      name: AppRoute.verfiyCodeSignUp, page: () => const VerfiyCodeSignUp()),
  GetPage(name: AppRoute.homepage, page: () => const home()),
  //Home
];
