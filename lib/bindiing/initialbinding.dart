import 'package:ecommercebig/core/class/crud.dart';
import 'package:get/get.dart';

class initialbinding extends Bindings {
  @override
  void dependencies() {
    Get.put(crud());
    
  }
}
