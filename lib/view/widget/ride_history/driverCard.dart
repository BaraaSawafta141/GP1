import 'package:flutter/material.dart';

class CardDriver extends StatelessWidget {
  const CardDriver(
      {Key? key,
      required this.source,
      required this.destination,
      required this.phone,
      required this.Username})
      : super(key: key);
  final String source;
  final String destination;
  final String phone;
  final String Username;
  @override
  Widget build(BuildContext context) {
    // Define text styles
    TextStyle staticTextStyle =
        TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red);
    TextStyle variableTextStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black);

    return Card(
      color: Colors.grey[200],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            isThreeLine: true,
            leading: const Icon(Icons.album),
            title: RichText(
              text: TextSpan(
                text: "Source: ",
                style: staticTextStyle,
                children: [
                  TextSpan(
                    text: source,
                    style: variableTextStyle,
                  ),
                ],
              ),
            ),
            subtitle: RichText(
              text: TextSpan(
                text: "Destination: ",
                style: staticTextStyle,
                children: [
                  TextSpan(
                    text: destination,
                    style: variableTextStyle,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: RichText(
              text: TextSpan(
                text: "Username: ",
                style: staticTextStyle,
                children: [
                  TextSpan(
                    text: Username,
                    style: variableTextStyle,
                  ),
                ],
              ),
            ),
            subtitle: Row(
              children: [
                Icon(Icons.phone),
                Text(
                  "Phone Number: +$phone",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
