import 'dart:io';
import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';
import 'package:ecommercebig/view/screen/home.dart';

class updateprofile {
  crud Crud;

  updateprofile(this.Crud);

  postdata(String username,String password) async {
    var response = await Crud.postData(applink.profile, {
      "username": username ,
      "password": password ,
      "id":Userid,
          });
    return response.fold((l) => l, (r) => r);
  }

  postRequestWithFile( File file) async {
    var response = await Crud.postRequestWithFile(applink.UploadImage, file,Userid!);
    return response;
  }
}
