// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String reciversId;
  final String senderEmail;
  final String message;
  final String senderId;
  final Timestamp timestamp;
  Message({
    required this.reciversId,
    required this.senderEmail,
    required this.message,
    required this.senderId,
    required this.timestamp,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reciversId': reciversId,
      'senderEmail': senderEmail,
      'message': message,
      'senderId': senderId,
      'timestamp': timestamp,
    };
  }
}
