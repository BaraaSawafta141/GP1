import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercebig/core/constant/color.dart';
import 'package:ecommercebig/view/screen/chat/chat_service.dart';
import 'package:ecommercebig/view/screen/driver/chat/chat_service_driver.dart';
import 'package:ecommercebig/view/screen/driver/driverhome.dart';
import 'package:ecommercebig/view/screen/home.dart';
import 'package:flutter/material.dart';

class chatDriver extends StatefulWidget {
  chatDriver({super.key, this.receiverId, this.name});
  final String? receiverId;
  final String? name;
  @override
  State<chatDriver> createState() => chatDriverState();
}

class chatDriverState extends State<chatDriver> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServiceDriver _chatService = ChatServiceDriver();

  void sendMessage() async {
    // only send message if the text field is not empty
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverId!, _messageController.text);
      // clear the text controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name!),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  // build the messages list
  Widget _buildMessagesList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverId!, driverId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Its Error!' + snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
            children: (snapshot.data as QuerySnapshot)
                .docs
                .map(
                  (document) => _buildMessageItem(document),
                )
                .toList());
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //align message to the right or left depending on the user
    var alignment = (data['senderId'] == driverId)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(children: [
        Text(data['senderName']),
        Text(data['message']),
      ]),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        //text field
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Type a message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),

        //send button
        IconButton(
          onPressed: sendMessage,
          icon: Icon(
            Icons.send,
            size: 40,
          ),
        ),
      ],
    );
  }
}
