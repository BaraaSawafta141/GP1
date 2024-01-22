import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercebig/core/constant/color.dart';
import 'package:ecommercebig/view/screen/driver/chat/chat_driver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class chatViewDriver extends StatefulWidget {
  const chatViewDriver({super.key});

  @override
  _chatViewDriverState createState() => _chatViewDriverState();
}

class _chatViewDriverState extends State<chatViewDriver> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: usersList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Search by name...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget usersList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Filter the list based on the search text
          final List<QueryDocumentSnapshot> filteredUsers =
              snapshot.data!.docs.where((doc) {
            final Map<String, dynamic> data =
                doc.data()! as Map<String, dynamic>;
            final String userName = data['name'].toString().toLowerCase();
            final String searchText = _searchController.text.toLowerCase();
            return userName.contains(searchText);
          }).toList();

          return ListView(
            children: filteredUsers
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
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
