import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class logindata {
  crud Crud;

  logindata(this.Crud);

  postdata(String password,String email) async {
    var response = await Crud.postData(applink.login, {
      "email": email ,
      "password": password ,
          });
    return response.fold((l) => l, (r) => r);
  }
}
