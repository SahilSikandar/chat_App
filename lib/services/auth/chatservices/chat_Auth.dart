import 'package:chat_app/model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// send Message
  Future<void> sendMessage(String reciverId, String message) async {
    final String currentId = _auth.currentUser!.uid;
    final String currentEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        reciversId: reciverId,
        senderEmail: currentEmail,
        message: message,
        senderId: currentEmail,
        timestamp: timestamp);

    List<String> ids = [currentId, reciverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection("Chat_room")
        .doc(chatRoomId)
        .collection("message")
        .add(newMessage.toMap());
  }

  //get message

  Stream<QuerySnapshot> getMessage(String userId, String otherId) {
    List<String> ids = [userId, otherId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection("Chat_room")
        .doc(chatRoomId)
        .collection("message")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
