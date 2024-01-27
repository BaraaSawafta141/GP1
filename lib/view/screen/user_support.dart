import 'package:ecommercebig/view/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Supportuser extends StatelessWidget {
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
        leading: InkWell(
            onTap: () {
              Get.to(home());
            },
            child: Icon(Icons.arrow_back)),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('palwheel2023@gmail.com'),
              onTap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'palwheel2023@gmail.com',
                  queryParameters: {
                    'subject': 'Support',
                  },
                );

                if (await canLaunchUrl(emailLaunchUri)) {
                  await launchUrl(emailLaunchUri);
                } else {
                  throw 'Could not launch $emailLaunchUri';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('+970 (595) 180806'),
              onTap: () async {
                final Uri phoneLaunchUri = Uri(
                  scheme: 'tel',
                  path: '+970595180806', // Replace with the actual phone number
                );

                if (await canLaunch(phoneLaunchUri.toString())) {
                  await launch(phoneLaunchUri.toString());
                } else {
                  throw 'Could not launch $phoneLaunchUri';
                }
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
                question: 'How to add a comment to a driver?',
                answer:
                    'To add a comment to a driver you can add a comment while waiting the driver and after you finish the ride '),
            FaqItem(
                question: 'How to book a ride?',
                answer:
                    'To book a ride you have to select the pick up location you want and then select the destination location after that you should choose a driver '),
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
