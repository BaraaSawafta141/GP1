import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';
import 'package:ecommercebig/view/screen/home.dart';

class rideHistorydata {
   crud Crud;

  rideHistorydata(this.Crud);

  postdata(String src,String dst, String time, String did) async {
    var response = await Crud.postData(applink.history, {
      "ride_history_src": src ,
      "ride_history_dst": dst ,
      "ride_history_time": time ,
      "did": did ,
      "email": UserEmail,
          });
    return response.fold((l) => l, (r) => r);
  }

 getdata() async {
    var response = await Crud.postData(applink.viewHistory, {
      "email": UserEmail});
    return response.fold((l) => l, (r) => r);
  }

}
