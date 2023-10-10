import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class checkconn extends StatefulWidget {
  const checkconn({super.key});

  @override
  State<checkconn> createState() => _checkconnState();
}

class _checkconnState extends State<checkconn> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();
  }

  void checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    print(result.name);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<ConnectivityResult>(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            return Scaffold(
              body: snapshot.data == ConnectivityResult.none
                  ? Center(child: Text("No Internet Connection"))
                  : Center(child: Text("Connected To Internet")),
            );
          }),
    );
  }
}
