import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class checkDriver {
  crud Crud;

  checkDriver(this.Crud);

  postdata(String phone) async {
    var response = await Crud.postDataCheckDriver(
      applink.checkDriver,
      {
        "phone": phone,
      }
    );
    print(">>");
    print(response);
    return response;
  }
}