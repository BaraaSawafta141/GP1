import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class approveRide {
  crud Crud;
  approveRide(this.Crud);
  postdata(String? rideId) async {
    var response = await Crud.postData2(applink.approveRide, {"rideId": rideId});
    return response;
  }
}