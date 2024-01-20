import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/functions/handlingdata.dart';
import 'package:ecommercebig/data/datasource/remote/driver/driverSignUp.dart';
import 'package:ecommercebig/data/datasource/remote/driver/driver_update.dart';
import 'package:ecommercebig/view/screen/driver/carinforegister/carinfotemplate.dart';
import 'package:ecommercebig/view/screen/driver/driverhome.dart';
import 'package:ecommercebig/view/screen/driver/driverprofile.dart';
import 'package:ecommercebig/view/screen/driver/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';

class DriverProfileupdate extends StatefulWidget {
  const DriverProfileupdate({Key? key}) : super(key: key);

  @override
  State<DriverProfileupdate> createState() => _DriverProfileupdateState();
}

String? driverId = driverServices.sharedPreferences.getString("id");

class _DriverProfileupdateState extends State<DriverProfileupdate> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  statusrequest statusreq = statusrequest.none;
  udpadedriver updateprofile = udpadedriver(Get.find());
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    print('Camera Permission Status: $status');
    if (status.isDenied) {
      await Permission.camera.request();
    } else if (status.isGranted) {
      await getImage(ImageSource.camera);
    }
  }

  updateData() async {
    if (nameController.text != "" &&
        emailController.text != "" &&
        selectedImage != null) {
      var response = await updateprofile.postdata(
          nameController.text, emailController.text, driverId!, selectedImage!);
      print(response);
      statusreq = handlingdata(response);
      if (statusrequest.success == statusreq) {
        if (response['status'] == "Success") {
          // driverId = response['id'];
          // } else {
          driverServices.sharedPreferences
              .setString("name", response['message']['drivers_name']);
          driverServices.sharedPreferences
              .setString("email", response['message']['drivers_email']);
          driverServices.sharedPreferences
              .setString("img", response['message']['drivers_photo']);
          FirebaseFirestore.instance
              .collection('drivers')
              .where('id', isEqualTo: driverId)
              .get()
              .then((value) {
            if (value.docs.isNotEmpty) {
              for (var element in value.docs) {
                element.reference
                    .update({'name': response['message']['drivers_name']});
              }
            } else {
              print("User not found");
            }
          }).catchError((error) {
            print("Error updating user name: $error");
          });

          AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: 'Success',
            desc: 'You have successfully updated your account',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              Get.to(homedriver());
            },
          ).show();
        } else {
          AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: 'warning',
            desc: 'You have not updated your account',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          ).show();
        }
      }
    } else {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Warning',
        desc: 'Please Enter Your Informations',
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
                      title: '', subtitle: 'Update Your Profile'),
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
                    SizedBox(
                      height: 50,
                    ),
                    greenButton(
                      'Submit',
                      () {
                        updateData();
                        //signUp();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: CircleAvatar(
                        radius: 28,
                        child: FloatingActionButton(
                          backgroundColor:
                              const Color.fromARGB(255, 61, 156, 64),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => homedriver()));
                          },
                          child: Icon(Icons.arrow_back),
                        )),
                  ),
                ],
              ),
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
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
            ],
          )),
    );
  }
}
