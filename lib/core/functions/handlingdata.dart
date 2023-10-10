import 'package:ecommercebig/core/class/statusrequest.dart';

handlingdata(response) {
  if (response is statusrequest) {
    return response;
  } else {
    return statusrequest.success;
  }
}
