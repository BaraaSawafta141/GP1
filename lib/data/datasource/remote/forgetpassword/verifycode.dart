import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class verifycodeforgetpassworddata{
  crud Crud;

  verifycodeforgetpassworddata(this.Crud);

  postdata(String verifycode,String email) async {
    var response = await Crud.postData(applink.verifycodeforgetpassword, {
      "email": email ,
      "verifycode": verifycode ,
          });
    return response.fold((l) => l, (r) => r);
  }
}
