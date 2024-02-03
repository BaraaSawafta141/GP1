import 'package:ecommercebig/bindiing/initialbinding.dart';
import 'package:ecommercebig/controller/driversectrycont.dart';
import 'package:ecommercebig/core/localization/translation.dart';
import 'package:ecommercebig/core/services/services.dart';
import 'package:ecommercebig/routes.dart';
import 'package:ecommercebig/view/screen/chat/test_view.dart';
import 'package:ecommercebig/view/screen/driver/chat/chat_view.dart';
import 'package:ecommercebig/view/screen/driver/driverhome.dart';
import 'package:ecommercebig/view/screen/driver/driverphonesectry.dart';
import 'package:ecommercebig/view/screen/driver/driverprofile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/localization/changelocal.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     if (message.notification != null) {
//         print("Handling a background message: ${message.notification!.body}");
//         Get.snackbar(
//           message.notification!.title!,
//           message.notification!.body!,
//           duration: const Duration(seconds: 5),
//         );
//       }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initialServices();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   if (message.notification != null) {
    //     if (message.data['type'] == 'chat') {
    //       driverId != null
    //           ? Get.to(() => chatViewDriver())
    //           : Get.to(() => testview());
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());
    return GetMaterialApp(
      translations: MyTranslation(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      locale: controller.language,
      theme: controller.appTheme,
      initialBinding: initialbinding(),
      // routes: routes,
      getPages: routes,
    );
  }
}

class CheckUserLoggedInOrNot extends StatefulWidget {
  const CheckUserLoggedInOrNot({super.key});

  @override
  State<CheckUserLoggedInOrNot> createState() => _CheckUserLoggedInOrNotState();
}

class _CheckUserLoggedInOrNotState extends State<CheckUserLoggedInOrNot> {
  @override
  void initState() {
    AuthService.isLoggedIn().then((value) {
      if (value) {
        Get.off(() => DriverProfileSetup());
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => DriverProfileSetup()));
      } else {
        Get.off(() => LoginPagesec());
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => LoginPagesec()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
