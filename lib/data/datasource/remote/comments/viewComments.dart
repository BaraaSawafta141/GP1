import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class viewComments {
  crud Crud;
  viewComments(this.Crud);

  postdata(String driverId) async {
    var response = await Crud.postData(applink.viewComments, {
      "driverId": driverId
    });
    return response.fold((l) => l, (r) => r);
  }

}
