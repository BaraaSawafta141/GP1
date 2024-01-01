import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class addingComments {
  crud Crud;
  addingComments(this.Crud);

  postdata(String userId, String info, double rate, String date, String driverId) async {
    var response = await Crud.postData(applink.addingComment, {
      "uid": userId,
      "info": info,
      "rate": rate.toString(),
      "date": date,
      "driverId": driverId
    });
    return response.fold((l) => l, (r) => r);
  }

}
