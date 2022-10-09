import 'package:chat_app/pages/groupInfo.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String username;

  const ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.username});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String admin = "";
  @override
  void initState() {
    getChatAdmin();
    super.initState();
  }

  getChatAdmin() {}
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.groupName),
        ),
        backgroundColor: const Color.fromARGB(255, 179, 14, 14),
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                context,
                GroupInfo(
                    groupId: widget.groupId,
                    groupName: widget.groupName,
                    adminname: admin),
              );
            },
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
