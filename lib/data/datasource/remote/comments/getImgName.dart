import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class userImgName {
  crud Crud;
  userImgName(this.Crud);

  postdata(String userId) async {
    var response = await Crud.postData(applink.imgName, {
      "uid": userId
    });
    return response.fold((l) => l, (r) => r);
  }

}
