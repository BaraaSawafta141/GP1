import 'package:ecommercebig/view/screen/auth/login.dart';
import 'package:ecommercebig/view/screen/driver/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DecisionScreen extends StatelessWidget {
  DecisionScreen({Key? key}) : super(key: key);

  //AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            taxiIntroWidget(),
            Center(
                child: Text(
              "39".tr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 30,
            ),
            DecisionButton('assets/images/driver.png', '40'.tr, () {
              //authController.isLoginAsDriver = true;
              Get.to(() => LoginScreen());
            }, Get.width * 0.8),
            const SizedBox(
              height: 20,
            ),
            DecisionButton('assets/images/user.png', '41'.tr, () {
              //authController.isLoginAsDriver = false;
              Get.to(() => Login());
            }, Get.width * 0.8),
          ],
        ),
      ),
    );
  }

  Widget DecisionButton(
      String icon, String text, Function onPressed, double width,
      {double height = 50}) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  spreadRadius: 1)
            ]),
        child: Row(
          children: [
            Container(
              width: 65,
              height: height,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 100, 167, 223),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
              child: Center(
                child: Image.asset(
                  icon,
                  width: 30,
                ),
              ),
            ),
            Expanded(
                child: Text(
              text,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
              textAlign: TextAlign.center,
            )),
          ],
        ),
      ),
    );
  }

  Widget taxiIntroWidget() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/taxiintro.png'),
              fit: BoxFit.fitWidth)),
      height: Get.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //SvgPicture.asset('assets/images/leaf.svg'),

          const SizedBox(
            height: 20,
          ),

          //SvgPicture.asset('assets/images/taxi.svg')
        ],
      ),
    );
  }
}
