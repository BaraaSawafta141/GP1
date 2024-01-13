import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SupportPage(),
    );
  }
}

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'If you have any questions or need assistance, feel free to contact us.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('majed1kawa3@gmail.com'),
              onTap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'majed1kawa3@gmail.com',
                  queryParameters: {'subject': 'Support Inquiry'},
                );

                if (await canLaunch(emailLaunchUri.toString())) {
                  await launch(emailLaunchUri.toString());
                } else {
                  throw 'Could not launch $emailLaunchUri';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('+1 (123) 456-7890'),
              onTap: () {
                // Make a phone call
              },
            ),
            Divider(),
            Text(
              'FAQs',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Add your frequently asked questions here
            FaqItem(
                question: 'How to create an account?',
                answer: 'To create an account...'),
            FaqItem(
                question: 'How to book a ride?', answer: 'To book a ride...'),
            // Add more FAQ items as needed
          ],
        ),
      ),
    );
  }
}

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(answer),
        ),
      ],
    );
  }
}
