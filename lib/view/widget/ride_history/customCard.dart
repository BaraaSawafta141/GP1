import 'package:flutter/material.dart';

class CardRideHistory extends StatelessWidget {
  const CardRideHistory({Key? key, required this.source, required this.destination, required this.time}) : super(key: key);
  final String source;
  final String destination;
  final String time;

  @override
  Widget build(BuildContext context) {
    // Define text styles
    TextStyle staticTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red);
    TextStyle variableTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.normal , color: Colors.black);
  
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
            leading: const Icon(Icons.timer_outlined),
            title: RichText(
              text: TextSpan(
                text: "Time: ",
                style: staticTextStyle,
                children: [
                  TextSpan(
                    text: time,
                    style: variableTextStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
