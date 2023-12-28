import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommercebig/controller/auth/login_controller.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/core/functions/validinput.dart';
import 'package:ecommercebig/data/datasource/remote/auth/profileupdate.dart';
import 'package:ecommercebig/view/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  updateprofile updateprof = updateprofile(Get.find());
  TextEditingController nameController = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  statusrequest statusreq = statusrequest.none;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  late LatLng homeAddress;
  late LatLng businessAddress;
  late LatLng shoppingAddress;
  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      await updateprof.postRequestWithFile(selectedImage!);
      userServices.sharedPreferences.setString(
          "image", "${userServices.sharedPreferences.getString("image")}");
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Success',
        desc: 'Your profile picture has been updated successfully',
        //btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("My Profile"),
        leading: InkWell(
          child: Icon(Icons.arrow_back),
          onTap: () {
            setState(() {});
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
                        getImage(ImageSource.gallery);
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
                key: formstate,
                child: Column(
                  children: [
                    Text(
                      "Change your data",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: Username,
                          prefixIcon: Icon(
                            Icons.person_outlined,
                            color: Colors.blue,
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (val) {
                        return validInput(val!, 3, 30, "password");
                      },
                      controller: passController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter a new password",
                          prefixIcon: Icon(
                            Icons.password,
                            color: Colors.blue,
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (val) {
                        return validInput(val!, 3, 30, "password");
                      },
                      controller: confirmpassController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Confirm your password",
                          prefixIcon: Icon(
                            Icons.password,
                            color: Colors.blue,
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    greenButton("Submit", () async {
                      if (passController.text != "" &&
                          confirmpassController.text == passController.text) {
                        if (formstate.currentState!.validate()) {
                          //statusreq = statusrequest.loading;
                          //update();
                          var response = await updateprof.postdata(
                              nameController.text, passController.text);
                          print(
                              "============================ Controller $response ");

                          statusreq = handlingdata(response);

                          if (statusrequest.success == statusreq) {
                            if (response['status'] == "Success") {
                              userServices.sharedPreferences.setString(
                                  "name", response['message']['users_name']);
                              userServices.sharedPreferences.setString(
                                  "password",
                                  response['message']['users_password']);
                            } else {
                              AwesomeDialog(
                                context: Get.context!,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: 'Warning',
                                desc: 'Email Or Password Not Correct',
                                //btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              ).show();
                              // Get.defaultDialog(
                              //     title: "Warning", middleText: "Email Or Password Not Correct");
                              statusreq = statusrequest.failure;
                            }
                          }
                          setState(() {});
                        } else {}
                      } else if (confirmpassController.text !=
                          passController.text) {
                        AwesomeDialog(
                          context: Get.context!,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'Warning',
                          desc: 'The Entered Paswwords Are Not Equal',
                          //btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        ).show();
                      }
                    })
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
