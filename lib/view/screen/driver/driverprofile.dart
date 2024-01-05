import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/data/datasource/remote/driver/driverSignUp.dart';
import 'package:ecommercebig/view/screen/driver/carinforegister/carinfotemplate.dart';
import 'package:ecommercebig/view/screen/driver/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';

class DriverProfileSetup extends StatefulWidget {
  const DriverProfileSetup({Key? key}) : super(key: key);

  @override
  State<DriverProfileSetup> createState() => _DriverProfileSetupState();
}

class _DriverProfileSetupState extends State<DriverProfileSetup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //AuthController authController = Get.find<AuthController>();
  statusrequest statusreq = statusrequest.none;
  signupdataDriver signupdata = signupdataDriver(Get.find());
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    print('Camera Permission Status: $status');
    if (status.isDenied) {
      // The user has denied camera permission.
      // You can show a custom message or UI to inform the user.

      // Request camera permission again.
      await Permission.camera.request();
    } else if (status.isGranted) {
      // Camera permission is already granted. Open the camera.
      await getImage(ImageSource.camera);
    }
  }

  signUp() async {
    if (nameController.text != "" &&
        emailController.text != "" &&
        selectedImage != null) {
      var response = await signupdata.postdata(
          nameController.text, emailController.text, phonenum!, selectedImage!);
      statusreq = handlingdata(response);
      if (statusrequest.success == statusreq) {
        if (response['status'] == "success") {
         driverServices.sharedPreferences
              .setString("id", response['id'].toString());
         driverServices.sharedPreferences
              .setString("name", response['data']['drivers_name'].toString());
         driverServices.sharedPreferences
              .setString("email", response['data']['drivers_email'].toString());     
         driverServices.sharedPreferences
              .setString("img", response['data']['drivers_photo']);          
           
          Get.off(() => carRegistertemplate());
        } else {
          AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: 'Warning',
            desc: 'Phone Number Or Email Already Exist',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          ).show();
          statusreq = statusrequest.failure;
        }
      }
    } else {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Warning',
        desc: 'Please Enter Your Name And Email and add your image',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    }
  }

  getImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedImage = File(image.path);
        setState(() {});
      }
    } catch (e) {
      // Handle the exception when permission is denied
      print("Permission denied to access the camera");
      // You can show a custom message or perform any other action here
      // Request camera permission again.
      await requestCameraPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Get.height * 0.4,
              child: Stack(
                children: [
                  greenIntroWidgetWithoutLogos(
                      title: 'Let’s Get Started!',
                      subtitle: 'Complete the profile Details'),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        getImage(ImageSource.camera);
                      },
                      child: selectedImage == null
                          ? Container(
                              width: 120,
                              height: 120,
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 2)
                              ], shape: BoxShape.circle, color: Colors.white),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                  color: Colors.black,
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
                                  color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 23),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "enter your name",
                          prefixIcon: Icon(
                            Icons.person_outlined,
                            color: Colors.green,
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "enter your email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.green,
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    greenButton(
                      'Submit',
                      () {
                        print(phonenum);
                        print(nameController.text);
                        print(emailController.text);
                        print(selectedImage != null
                            ? selectedImage!.path
                            : "equals Null <<<<<<<<");
                        signUp();
                      },
                    ),
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
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 1)
              ],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            readOnly: readOnly,
            //onTap: () => onTap!(),
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
                  color: Colors.green,
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
      color: Colors.green,
      onPressed: () => onPressed(),
      child: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget greenIntroWidgetWithoutLogos(
      {String title = "Profile Settings", String? subtitle}) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/mask.png'), fit: BoxFit.fill)),
      height: Get.height * 0.3,
      child: Container(
          height: Get.height * 0.1,
          width: Get.width,
          margin: EdgeInsets.only(bottom: Get.height * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
            ],
          )),
    );
  }
}
