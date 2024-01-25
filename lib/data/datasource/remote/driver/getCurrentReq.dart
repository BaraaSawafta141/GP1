import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class getCurrentReq {
  crud Crud;
  getCurrentReq(this.Crud);
  postdata(String? did) async {
    var response = await Crud.postData2(applink.getCurrentReq, {"did": did});
    return response;
  }
}