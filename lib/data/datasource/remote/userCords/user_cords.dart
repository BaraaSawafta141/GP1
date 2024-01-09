import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class addLatLongUser{
  crud Crud;

  addLatLongUser(this.Crud);

  postdata(String? lat , String? long, String? uid) async {
    var response = await Crud.postData(
      applink.userCords,
     {
        "lat": lat,
        "long": long,
        "uid": uid
     }
    );
    // print(response);
    return response;
  }
}