import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercebig/view/screen/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ecommercebig/model/message.dart' as model;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

        ChatService() {
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: _onSelectNotification,
    );
  }
 
  Future<void> sendMessage(String recevierId, String message) async {
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
  // Trigger local notification
    await _showNotification(recevierId, message);
  }
  Future<void> _showNotification(String receiverId, String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', 'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New Message',
      'You have a new message from $receiverId',
      platformChannelSpecifics,
      payload: 'chatUser|$receiverId', // You can customize the payload as needed
    );
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
