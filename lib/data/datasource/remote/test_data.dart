import 'package:ecommercebig/core/class/crud.dart';
import 'package:ecommercebig/linkapi.dart';

class testData {
  crud Crud;

  testData(this.Crud);

  getData() async {
    var response = await Crud.postData(applink.test, {});
    return response.fold((l) => l, (r) => r);
  }
}
