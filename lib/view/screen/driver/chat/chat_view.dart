import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercebig/core/constant/color.dart';
import 'package:ecommercebig/view/screen/driver/chat/chat_driver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class chatViewDriver extends StatelessWidget {
  const chatViewDriver({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put(testcontroller());
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        backgroundColor: AppColor.primaryColor,
      ),
      body: usersList(),
    );
  }

  Widget usersList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Its Error!');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
              children: snapshot.data!.docs
                  .map<Widget>((doc) => _buildUserListItem(doc))
                  .toList());
        });
  }

Widget _buildUserListItem(DocumentSnapshot document) {
  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
  return ListTile(
    title: Text(data['name']),
    // subtitle: Text(data['uid']),
    onTap: () {
      Get.to(() => chatDriver(
            receiverId: data['uid'],
            name: data['name'],
      ));
    },
  );
}
}


