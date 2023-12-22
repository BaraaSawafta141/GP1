import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController homeController = TextEditingController();
  TextEditingController businessController = TextEditingController();
  TextEditingController shopController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  late LatLng homeAddress;
  late LatLng businessAddress;
  late LatLng shoppingAddress;
  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("My Profile"),
        leading:  InkWell(child: Icon(Icons.arrow_back),
        onTap: (){
          Get.back();
        },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Get.height * 0.3,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        getImage(ImageSource.camera);
                      },
                      child: selectedImage == null
                          ? Container(
                              width: 120,
                              height: 120,
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffD6D6D6)),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(
                              width: 120,
                              height: 120,
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(selectedImage!),
                                      fit: BoxFit.fill),
                                  shape: BoxShape.circle,
                                  color: Color(0xffD6D6D6)),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 23),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "enter your name",
                          prefixIcon: Icon(
                            Icons.person_outlined,
                            color: Colors.blue,
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Home Address",
                          prefixIcon: Icon(
                            Icons.home_outlined,
                            color: Colors.blue,
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Business Address",
                          prefixIcon: Icon(
                            Icons.card_travel_outlined,
                            color: Colors.blue,
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Shopping Center",
                          prefixIcon: Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.blue,
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    /*Obx(() => authController.isProfileUploading.value
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : greenButton('Submit', () {


                            if(!formKey.currentState!.validate()){
                              return;
                            }

                            if (selectedImage == null) {
                              Get.snackbar('Warning', 'Please add your image');
                              return;
                            }
                            /*authController.isProfileUploading(true);
                            authController.storeUserInfo(
                                selectedImage!,
                                nameController.text,
                                homeController.text,
                                businessController.text,
                                shopController.text,
                                businessLatLng: businessAddress,
                              homeLatLng: homeAddress,
                              shoppingLatLng: shoppingAddress
                              );*/
                          })),*/
                    greenButton("Submit", () {})
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextFieldWidget(String title, IconData iconData,
      TextEditingController controller, Function validator,
      {Function? onTap, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xffA7A7A7)),
        ),
        const SizedBox(
          height: 6,
        ),
        Container(
          width: Get.width,
          // height: 50,
          decoration: BoxDecoration(
              color: Colors.grey,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 1)
              ],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            readOnly: readOnly,
            onTap: () => onTap!(),
            validator: (input) => validator(input),
            controller: controller,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xffA7A7A7)),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  iconData,
                  color: Colors.blue,
                ),
              ),
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }

  Widget greenButton(String title, Function onPressed) {
    return MaterialButton(
      minWidth: Get.width,
      height: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: Colors.blue,
      onPressed: () => onPressed(),
      child: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
