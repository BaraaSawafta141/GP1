import 'package:ecommercebig/controller/test_controller.dart';
import 'package:ecommercebig/core/class/handlingdataview.dart';
import 'package:ecommercebig/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class testview extends StatelessWidget {
  const testview({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(testcontroller());
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
        backgroundColor: AppColor.primaryColor,
      ),
      body: GetBuilder<testcontroller>(builder: (controller) {
        return handlingdataview(
          statusreq:controller.statusreq, widget: ListView.builder(
              itemCount: controller.data.length,
              itemBuilder: (context, index) {
                return Text("${controller.data}");
              }),);

        
        
      }),
    );
  }
}
