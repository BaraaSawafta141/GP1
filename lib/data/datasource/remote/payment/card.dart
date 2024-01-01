import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';
import 'package:ecommercebig/view/screen/home.dart';

class cardData {
  crud Crud;

  cardData(this.Crud);

  postdata(String username,String cvv,String expiryDate,String cardNumber) async {
    var response = await Crud.postData(applink.Card, {
      "username": username ,
      "cvv": cvv ,
      "expDate": expiryDate ,
      "cardNumber": cardNumber ,
      "id": Userid,
          });
    return response.fold((l) => l, (r) => r);
  }

 getdata() async {
    var response = await Crud.postData(applink.viewCard, {
      "id": Userid});
    return response.fold((l) => l, (r) => r);
  }

}
