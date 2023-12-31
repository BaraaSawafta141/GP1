import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/functions/checkinternet.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

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

  postRequestWithFile(String linkurl, File file, String uid) async {
    print(linkurl);
    print(uid);
    print(file.path);
    var request = http.MultipartRequest('POST', Uri.parse(linkurl));
    var length = await file.length();
    var stream = http.ByteStream(file.openRead());
    var multipartFile = http.MultipartFile('image', stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);
    request.fields.addAll({"id": uid});
    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return print("Uploaded");
    } else {
      return print("Error ${response.statusCode}");
    }
  }

  postRequestWithFileDriver(String linkurl, File file, String name,
      String email, String phone) async {
    print(linkurl);
    print(file.path);
    var request = http.MultipartRequest('POST', Uri.parse(linkurl));
    var length = await file.length();
    var stream = http.ByteStream(file.openRead());
    var multipartFile = http.MultipartFile('image', stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);
    request.fields.addAll({"name": name, "email": email, "phone": phone});

    try {
      var myrequest = await request.send();
      var response = await http.Response.fromStream(myrequest);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return "Error ${response.statusCode}";
      }
    } catch (error) {
      return "Error: $error";
    }
  }

 getData(String linkurl) async {
    try {
      if (await checkinternet()) {
        var response = await http.get(Uri.parse(linkurl));
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map responsebody = jsonDecode(response.body);
          // print(responsebody);
          return responsebody;
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
