import 'dart:convert';


import 'package:ecommercebig/core/constant/imageasset.dart';
import 'package:ecommercebig/core/functions/checkinternet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _nameState();
}

class _nameState extends State<test> {
  //this code to check internet
  /* var res;

  initialdata() async {
    res = await checkinternet();
     print(res);
  }

  @override
  void initState() async {
    initialdata();
   
    super.initState();
  }*/
//till here to check internet and there is nother page called checkinternet.dart

  TextEditingController _controller = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken == uuid.v4();
      });
    }

    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String places_key = "AIzaSyAWw0O5296K5kLNisnYj5YiRBKzMh5Dpq4";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$places_key&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    print('data');
    print(data);

    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'search places with name'),
            ),
            Expanded(
                child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: _placesList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          List<Location> locations = await locationFromAddress(
                              _placesList[index]['description']);
                          print(locations.last.longitude);
                          print(locations.last.latitude);
                        },
                        title: Text(_placesList[index]['description']),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
