import 'package:ecommercebig/view/screen/emergency.dart';
import 'package:ecommercebig/view/screen/home.dart';
import 'package:ecommercebig/view/screen/maptheme.dart';
import 'package:ecommercebig/view/screen/myprofile.dart';
import 'package:ecommercebig/view/screen/payment/payment.dart';
import 'package:ecommercebig/view/widget/testfolder/test.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(children: [
        InkWell(
          onTap: () {
            Get.to(() => ProfileSettingScreen());
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
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/images/profile.png'))),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Hello , ',
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 20)),
                      Text(
                        /*authController.myUser.value.name == null
                                ? "Mark"
                                : authController.myUser.value.name!,*/
                        "Mark",
                        style: GoogleFonts.poppins(
                            fontSize: 24,
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
              buildDrawerItem(
                  title: 'Payment History',
                  onPressed: () {
                    Get.off(() => PaymentScreen());
                  }),
              buildDrawerItem(
                  title: 'Ride History', onPressed: () {}, isVisible: true),
              buildDrawerItem(
                  title: 'Emergency',
                  onPressed: () {
                    Get.to(SOSPage());
                  }),
              buildDrawerItem(
                  title: 'Custom map',
                  onPressed: () {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>maptheme()));
                    Get.to(() => maptheme());
                  }),
              buildDrawerItem(title: 'Settings', onPressed: () {}),
              buildDrawerItem(title: 'Support', onPressed: () {}),
              buildDrawerItem(
                  title: 'Log Out',
                  onPressed: () {
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
    );
  }
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
