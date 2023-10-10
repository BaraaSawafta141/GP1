import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class signupdata {
  crud Crud;

  signupdata(this.Crud);

  postdata(String username,String password,String email,String phone) async {
    var response = await Crud.postData(applink.signup, {
      "username": username ,
      "password": password ,
      "email": email ,
      "phone": phone ,
          });
    return response.fold((l) => l, (r) => r);
  }
}
