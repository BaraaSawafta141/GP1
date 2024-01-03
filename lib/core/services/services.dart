import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;
  late FirebaseApp firebaseApp;
  Future<MyServices> init() async {
    Platform.isAndroid?
    await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBxnub0C_RIxdWUKMW1V1SN9IwlIw-sNZ0",
      appId:"1:111878878990:android:acdb15dcb34783d49b495f",
      messagingSenderId: "111878878990",
      projectId:"ecommercebig",
    ),
  )
    :await Firebase.initializeApp();
    sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }
}

initialServices() async {
  await Get.putAsync(() => MyServices().init());
}
