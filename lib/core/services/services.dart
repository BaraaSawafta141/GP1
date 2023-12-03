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
      apiKey: "AIzaSyAL7ys5KeFJ_hF5UgHjRdnfcEkxd1m7o88",
      appId: "1:195865025194:android:dc2e6e81a15cbce7b00ed3",
      messagingSenderId: "195865025194",
      projectId: "phoneverify-cbcf1",
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
