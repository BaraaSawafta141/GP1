import 'dart:io';

import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class viewDriversData {
  crud Crud;
  viewDriversData(this.Crud);

  getData() async {
    var response = await Crud.getData(applink.viewDrivers);
    // print(response);
    return response;
  }
}
