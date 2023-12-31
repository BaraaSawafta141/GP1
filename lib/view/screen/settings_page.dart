import 'package:flutter/material.dart';

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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Profile'),
              leading: Icon(Icons.person),
              onTap: () {
                // Navigate to profile settings
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettings()));
              },
            ),
            ListTile(
              title: Text('Payment Methods'),
              leading: Icon(Icons.payment),
              onTap: () {
                // Navigate to payment settings
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentSettings()));
              },
            ),
            Divider(),
            Text(
              'App Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Notifications'),
              leading: Icon(Icons.notifications),
              onTap: () {
                // Navigate to notification settings
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationSettings()));
              },
            ),
            ListTile(
              title: Text('Privacy'),
              leading: Icon(Icons.lock),
              onTap: () {
                // Navigate to privacy settings
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacySettings()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
