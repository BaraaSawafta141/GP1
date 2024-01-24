import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class addLatLong{
  crud Crud;

  addLatLong(this.Crud);

  postdata(String? lat , String? long, String? did) async {
    var response = await Crud.postData(
      applink.addLatLong,
     {
        "lat": lat,
        "long": long,
        "did": did
     }
    );
    // print(response);
    return response;
  }
}