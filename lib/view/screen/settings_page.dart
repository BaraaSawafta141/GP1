import 'package:ecommercebig/view/screen/myprofile.dart';
import 'package:ecommercebig/view/screen/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        elevation: 0, // No shadow
        backgroundColor: Colors.blue, // Use your preferred color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Settings',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Profile'),
              leading: Icon(Icons.person),
              onTap: () {
                // Navigate to profile settings
                Get.to(() => ProfileSettingScreen());
              },
            ),
            ListTile(
              title: Text('Payment Methods'),
              leading: Icon(Icons.payment),
              onTap: () {
                // Navigate to payment settings
                Get.to(() => PaymentScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
