import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class verifycodesignup {
  crud Crud;

  verifycodesignup(this.Crud);

  postdata(String email,String verifycode) async {
    var response = await Crud.postData(applink.verifycodesignup, {
      "email": email ,
      "verifycode": verifycode ,
          });
    return response.fold((l) => l, (r) => r);
  }
}
