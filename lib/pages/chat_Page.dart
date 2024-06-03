import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/ktextfeild.dart';
import 'package:chat_app/services/auth/chatservices/chat_Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String reciversEmail;
  final String reciversId;
  const ChatPage(
      {super.key, required this.reciversEmail, required this.reciversId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatServices _services = ChatServices();
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _services.sendMessage(widget.reciversId, _messageController.text);
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text(
              widget.reciversEmail,
              style: const TextStyle(color: Colors.white),
            )),
        body: Column(
          children: [
            Expanded(child: _buildMessageList()),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: _buildTextField(),
            )
          ],
        ));
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _services.getMessage(widget.reciversId, _auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return ListView(
            children: snapshot.data!.docs
                .map((documnets) => _buildMessageItem(documnets))
                .toList());
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot documnets) {
    Map<String, dynamic> data = documnets.data() as Map<String, dynamic>;

    var aligment = (data['reciversId'] == _auth.currentUser!.uid)
        ? Alignment.centerLeft
        : Alignment.centerRight;
    return Container(
      alignment: aligment,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: (data['reciversId'] == _auth.currentUser!.uid)
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          mainAxisAlignment: (data['reciversId'] == _auth.currentUser!.uid)
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            Text(data['senderEmail']),
            ChatBubble(message: data['message'])
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Row(
      children: [
        Expanded(
          child: KtextField(
              type: TextInputType.name,
              controller: _messageController,
              hintText: "Enter message",
              obscureText: false),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              )),
        )
      ],
    );
  }
}
