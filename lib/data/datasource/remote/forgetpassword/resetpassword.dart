import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class resetpassworddata {
  crud Crud;

  resetpassworddata(this.Crud);

  postdata(String password,String email) async {
    var response = await Crud.postData(applink.resetpassword, {
      "email": email ,
      "password": password ,
          });
    return response.fold((l) => l, (r) => r);
  }
}
