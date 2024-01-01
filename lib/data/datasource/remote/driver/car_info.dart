import 'dart:io';
import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class carInfoData {
  crud Crud;

  carInfoData(this.Crud);

  postdata(String location, String type, String company,String model ,String number ,String color ,String driverid ,File file) async {
    var response = await Crud.postRequestWithFileCar(
      applink.carInfo,
      location,
      type,
      company,
      model,
      number,
      color,
      driverid,
      file,
    );
    print(response);
    return response;
  }
}