import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class reserveDriverData{
  crud Crud;
  reserveDriverData(this.Crud);

  postdata(String driverId) async {
    var response = await Crud.changeAvailability(applink.reserveDriver, {
      "driver_id": driverId
    });
    return response;
  }
}
