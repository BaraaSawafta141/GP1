import 'package:ecommercebig/view/screen/driver/driverloginphone.dart';
import 'package:ecommercebig/view/screen/driver/mobileverify.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginScreen extends StatefulWidget {
  const  LoginScreen({Key? key}) : super(key: key);


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final countryPicker = const FlCountryCodePicker();

  CountryCode countryCode = CountryCode(name: 'Palestine', code: "PS", dialCode: "+970");


  onSubmit(String? input){
    Get.to(()=>OtpVerificationScreen(countryCode.dialCode+input!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              greenIntroWidget(),

              const SizedBox(height: 50,),

              loginWidget(countryCode,()async{
                final code = await countryPicker.showPicker(context: context);
                if (code != null)  countryCode = code;
                setState(() {

                });
              },onSubmit),


            ],
          ),
        ),
      ),
    );
  }
  Widget greenIntroWidget(){
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/mask.png'),
        fit: BoxFit.cover
      )
    ),
    height: Get.height*0.6,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Text("Driver Verification",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
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