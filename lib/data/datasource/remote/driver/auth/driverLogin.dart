import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class driverLogin {
  crud Crud;
  driverLogin(this.Crud);
  postdata(String? phoneNum, String? password) async {
    var response = await Crud.postData2(applink.loginDriver, {
      "phone": phoneNum,
      "password": password,
    });
    return response;
  }
}
