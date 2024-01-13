import 'package:ecommercebig/core/middleware/mymiddleware.dart';
import 'package:ecommercebig/view/screen/driver/SOSPageDriver.dart';
import 'package:ecommercebig/view/screen/driver/chat/chat_view.dart';
import 'package:ecommercebig/view/screen/driver/choosingscreen.dart';
import 'package:ecommercebig/view/screen/driver/driverSettingsPage.dart';
import 'package:ecommercebig/view/screen/driver/driverSupport.dart';
import 'package:ecommercebig/view/screen/driver/driverhome.dart';
import 'package:ecommercebig/view/screen/driver/loginscreen.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommercebig/linkapi.dart';
// int RideCount = 0;

class CustomDrawerDriver extends StatelessWidget {
  const CustomDrawerDriver({Key? key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        // width: Get.width / 1.4,
        color: Colors.white,
        child: Column(children: [
          InkWell(
            onTap: () {
              // Get.to(() => DriverProfileupdate());
            },
            child: SizedBox(
              height: 150,
              child: DrawerHeader(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      //color: Colors.red,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: driverPhoto == ""
                              ? AssetImage('assets/images/profile.png')
                                  as ImageProvider<Object>
                              : NetworkImage(
                                  applink.linkImageRoot + '/$driverPhoto'),
                          fit: BoxFit.fill),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Hello ,',
                            style: GoogleFonts.poppins(
                                color: Colors.black, fontSize: 20)),
                        Text(
                          drivername!,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                      ],
                    ),
                  )
                ],
              )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                // buildDrawerItem(
                //     title: 'Payment History',
                //     onPressed: () {
                //       Get.to(() => PaymentScreen());
                //     }),
                buildDrawerItem(
                    title: 'Ride History',
                    onPressed: () {
                      // Get.to(() => rideHistory());
                    }),
                buildDrawerItem(
                    title: 'Emergency',
                    onPressed: () {
                      Get.to(SOSPageDriver());
                    }),
                buildDrawerItem(
                    title: 'Chat',
                    onPressed: () {
                      Get.to(chatViewDriver());
                    }),
                buildDrawerItem(
                    title: 'Custom map',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Change Map Theme'),
                              content: const Text(
                                'Choose your preferred map theme:',
                              ),
                              actions: <Widget>[
                                ListTile(
                                    title: Text('Silver'),
                                    onTap: () async {
                                      await setMapTheme('silver');
                                      mymapcontroller?.setMapStyle(
                                        await rootBundle.loadString(
                                            'assets/maptheme/silver.txt'),
                                      );
                                      Get.back();
                                    }),
                                ListTile(
                                    title: Text('Retro'),
                                    onTap: () async {
                                      await setMapTheme('retro');

                                      mymapcontroller?.setMapStyle(
                                        await rootBundle.loadString(
                                            'assets/maptheme/retro.txt'),
                                      );
                                      Get.back();
                                    }),
                                ListTile(
                                    title: Text('Night'),
                                    onTap: () async {
                                      await setMapTheme('night');
                                      mymapcontroller?.setMapStyle(
                                        await rootBundle.loadString(
                                            'assets/maptheme/night.txt'),
                                      );
                                      Get.back();
                                    }),
                              ],
                            );
                          });
                    }),
                buildDrawerItem(
                    title: 'Settings',
                    onPressed: () {
                      Get.to(() => DriverSettingsPage());
                    }),
                buildDrawerItem(title: 'Support', onPressed: () {
                  Get.to(() => SupportDriver());
                }),
                buildDrawerItem(
                    title: 'Log Out',
                    onPressed: () {
                      myServices.sharedPreferences.setString("homedriver", "0");
                      driverServices.sharedPreferences.setString("id", "");
                      driverServices.sharedPreferences.setString("name", "");
                      driverServices.sharedPreferences.setString("email", "");
                      driverServices.sharedPreferences.setString("img", "");
                      Get.offAll(() => DecisionScreen(),
                          transition: Transition.rightToLeft);
                      //FirebaseAuth.instance.signOut();
                    }),
              ],
            ),
          ),
          Spacer(),
          Divider(),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}

// Function to save the chosen map theme to shared preferences
Future<void> setMapTheme(String theme) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('map_theme_d', theme);
}

buildDrawerItem(
    {required String title,
    required Function onPressed,
    Color color = Colors.black,
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w700,
    double height = 45,
    bool isVisible = false}) {
  return SizedBox(
    height: height,
    child: ListTile(
      contentPadding: EdgeInsets.all(0),
      // minVerticalPadding: 0,
      dense: true,
      onTap: () => onPressed(),
      title: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: fontSize, fontWeight: fontWeight, color: color),
          ),
          const SizedBox(
            width: 5,
          ),
          isVisible
              ? CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 15,
                  child: Text(
                    '1',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                )
              : Container()
        ],
      ),
    ),
  );
}
