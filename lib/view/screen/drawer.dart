import 'package:ecommercebig/controller/auth/login_controller.dart';
import 'package:ecommercebig/core/middleware/mymiddleware.dart';
import 'package:ecommercebig/view/screen/chat/test_view.dart';
import 'package:ecommercebig/view/screen/auth/login.dart';
import 'package:ecommercebig/view/screen/driver/choosingscreen.dart';
import 'package:ecommercebig/view/screen/emergency.dart';
import 'package:ecommercebig/view/screen/home.dart';
import 'package:ecommercebig/view/screen/myprofile.dart';
import 'package:ecommercebig/view/screen/payment/payment.dart';
import 'package:ecommercebig/view/screen/ridehistory.dart';
import 'package:ecommercebig/view/screen/settings_page.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommercebig/linkapi.dart';
// int RideCount = 0;

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        // width: Get.width / 1.4,
        color: Colors.white,
        child: Column(children: [
          InkWell(
            // onTap: () {
              // Get.to(() => ProfileSettingScreen());
            // },
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
                          image: UserPhoto == ""
                              ? AssetImage('assets/images/profile.png')
                                  as ImageProvider<Object>
                              : NetworkImage(
                                  applink.linkImageRoot + '/$UserPhoto'),
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
                          Username!,
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
                      Get.to(() => rideHistory());
                    }),
                buildDrawerItem(
                    title: 'Emergency',
                    onPressed: () {
                      Get.to(SOSPage());
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
                      Get.to(() => SettingsPage());
                    }),
                buildDrawerItem(
                    title: 'Chat',
                    onPressed: () {
                      Get.to(() => testview());
                    }),
                buildDrawerItem(title: 'Support', onPressed: () {}),
                buildDrawerItem(
                    title: 'Log Out',
                    onPressed: () {
                      myServices.sharedPreferences.setString("Login", "0");
                      userServices.sharedPreferences.setString("name", "");
                      userServices.sharedPreferences.setString("password", "");
                      userServices.sharedPreferences.setString("image", "");
                      Get.offAll(() => DecisionScreen(),
                          transition: Transition.rightToLeft);
                      //FirebaseAuth.instance.signOut();
                    }),
              ],
            ),
          ),
          Spacer(),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: [
                buildDrawerItem(
                    title: 'Do more',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    height: 20),
                const SizedBox(
                  height: 20,
                ),
                buildDrawerItem(
                    title: 'Get food delivery',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    height: 20),
                buildDrawerItem(
                    title: 'Make money driving',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    height: 20),
                buildDrawerItem(
                  title: 'Rate us on store',
                  onPressed: () {},
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  height: 20,
                ),
              ],
            ),
          ),
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
  prefs.setString('map_theme', theme);
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
