import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercebig/controller/test_controller.dart';
import 'package:ecommercebig/core/class/handlingdataview.dart';
import 'package:ecommercebig/core/constant/color.dart';
import 'package:ecommercebig/view/screen/chat/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class testview extends StatefulWidget {
  const testview({super.key});

  @override
  _testviewState createState() => _testviewState();
}

class _testviewState extends State<testview> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get.put(testcontroller());
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
        backgroundColor: AppColor.primaryColor,
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
          // Call a function to filter the list based on the entered text
          // You can implement the filtering logic in a separate method
          // For simplicity, I'll filter the list directly in this onChanged callback
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
        stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Filter the list based on the search text
          final List<QueryDocumentSnapshot> filteredDrivers = snapshot.data!.docs
              .where((doc) {
                final Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                final String driverName = data['name'].toString().toLowerCase();
                final String searchText = _searchController.text.toLowerCase();
                return driverName.contains(searchText);
              })
              .toList();

          return ListView(
            children: filteredDrivers
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
        Get.to(() => chatUser(
              receiverId: data['id'],
              name: data['name'],
            ));
      },
    );
  }
}
