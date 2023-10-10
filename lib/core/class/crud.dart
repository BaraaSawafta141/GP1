import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/functions/checkinternet.dart';
import 'package:http/http.dart' as http;

class crud {
  Future<Either<statusrequest, Map>> postData(String linkurl, Map data) async {
    try {
      if (await checkinternet()) {
        var response = await http.post(Uri.parse(linkurl), body: data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map responsebody = jsonDecode(response.body);
          print(responsebody);
          return Right(responsebody);
        } else {
          return left(statusrequest.serverFailure);
        }
      } else {
        return left(statusrequest.offlineFailure);
      }
    } catch (_) {
      return left(statusrequest.serverexception);
    }
  }
}
