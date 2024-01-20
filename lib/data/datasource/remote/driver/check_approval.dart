import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class checkApproval {
  crud Crud;

  checkApproval(this.Crud);

  postdata(String did) async {
    var response =
        await Crud.postDataDriver(applink.driverApproval, {"id": did});
    return response;
  }
}
