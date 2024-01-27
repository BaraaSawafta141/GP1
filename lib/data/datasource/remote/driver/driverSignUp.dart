import 'dart:io';

import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class signupdataDriver {
  crud Crud;

  signupdataDriver(this.Crud);

  postdata(String name, String email, String phone, String password,File image) async {
    var response = await Crud.postRequestWithFileDriver(
      applink.driverSignUp,
      image,
      name,
      email,
      phone,
      password,
    );
    print(response);
    return response;
  }
}
