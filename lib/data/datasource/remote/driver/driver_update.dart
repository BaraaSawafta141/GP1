import 'dart:io';

import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';
import 'package:ecommercebig/view/screen/driver/driverprofile.dart';

class udpadedriver {
  crud Crud;

  udpadedriver(this.Crud);

  postdata(String name, String email ,String driverId,File image) async {
    var response = await Crud.postRequestWithFileDriverupdate(
      applink.updateDrivers,
      image,
      name,
      email,
      driverId
    );
    print(response);
    return response;
  }
}
