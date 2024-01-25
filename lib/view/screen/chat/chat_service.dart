import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercebig/view/screen/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ecommercebig/model/message.dart' as model;

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(
      String recevierId, String message, String token) async {
    // get current user data
    final String currentUserId = Userid!;
    final String currentUserName = Username!;
    final Timestamp timestamp = Timestamp.now();
    // create a new message
    model.Message messageObj = model.Message(
      senderId: currentUserId,
      senderName: currentUserName,
      receiverId: recevierId,
      message: message,
      timestamp: timestamp,
    );
    // construct chat id
    List<String> ids = [currentUserId, recevierId];
    ids.sort(); // sort the ids to avoid duplicate chat ids
    String chatId = ids.join('_'); // join the ids with underscore
    //add new message to firestore
    await _firestore
        .collection('chat_rooms')
        .doc(chatId)
        .collection('messages')
        .add(messageObj.toMap());

    await sendMessageNotificaiton(
      'Message from $currentUserName',
      message,
      token,
      'chat',
      'chat',
    );
    // // Trigger local notification
    //   await _showNotification(currentUserId, message, currentUserName);
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // construct chat room id from user ids
    // final String currentUserId = Userid!;
    // construct chat id
    List<String> ids = [userId, otherUserId];
    ids.sort(); // sort the ids to avoid duplicate chat ids
    String chatId = ids.join('_'); // join the ids with underscore
    // get messages
    return _firestore
        .collection('chat_rooms')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
