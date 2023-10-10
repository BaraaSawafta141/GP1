import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class checkemaildata {
  crud Crud;

  checkemaildata(this.Crud);

  postdata(String email) async {
    var response = await Crud.postData(applink.checkemail, {
      "email": email ,
      
          });
    return response.fold((l) => l, (r) => r);
  }
}
