import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/data/datasource/remote/test_data.dart';
import 'package:get/get.dart';

class testcontroller extends GetxController {
  testData testdata = testData(Get.find());

  List data = [];

  late statusrequest statusreq;

  getData() async {
    statusreq = statusrequest.loading;
    var response = await testdata.getData();
    print("============================ Controller $response ");
    statusreq = handlingdata(response);

    if (statusrequest.success == statusreq) {
      if (response['success'] == "success") {
        data.addAll(response['data']);
      } else {
        statusreq = statusrequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
