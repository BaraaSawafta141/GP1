import 'dart:async';

import 'package:ecommercebig/view/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SOSPage extends StatefulWidget {
  @override
  _SOSPageState createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  int _countdown = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Get.to(home());
              },
              child: Icon(
                Icons.close,
              ),
            ),
            Text(
              'Emergency',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 100),
            Text(
              'Don\'t Worry',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              'Our support team will contact with you',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$_countdown sec',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "If call doesn't connect in 60 sec your details ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "will be sent to nearby police station",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 140),
            Container(
              width: 250,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // Add logic for emergency contact button
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
                child: Text(
                  'Emergency Contact',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
