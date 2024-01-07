import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class becomeAvailable{
  crud Crud;
  becomeAvailable(this.Crud);

  postdata(String driverId) async {
    var response = await Crud.changeAvailability(applink.makeAvailable, {
      "driver_id": driverId
    });
    return response;
  }
}
