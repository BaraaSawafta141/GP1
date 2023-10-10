import 'package:ecommercebig/core/constant/imageasset.dart';
import 'package:ecommercebig/core/functions/checkinternet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:lottie/lottie.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _nameState();
}

class _nameState extends State<test> {
  //this code to check internet
 /* var res;

  initialdata() async {
    res = await checkinternet();
     print(res);
  }

  @override
  void initState() async {
    initialdata();
   
    super.initState();
  }*/
//till here to check internet and there is nother page called checkinternet.dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Container(
          child: ListView(children: [
            Lottie.asset(AppImageAsset.nodata),
            
          ]),
        ),
      ),
    );
  }
}
