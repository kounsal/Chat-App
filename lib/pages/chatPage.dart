import 'package:chat_app/pages/groupInfo.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/chat_tiles.dart';

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
  Stream<QuerySnapshot>? chats;
  String admin = "";

  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }

  getChatAndAdmin() {
    DatabaseService().getChat(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

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
      body: Stack(
        children: [
          chatbody(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        hintText: "Send a Message",
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(onPressed: sendmessage, icon: Icon(Icons.send))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  chatbody() {
    return SafeArea(
      child: StreamBuilder(
          stream: chats,
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return MessageTile(
                        message: snapshot.data.docs[index]["message"],
                        sentByMe: widget.username ==
                            snapshot.data.docs[index]["sender"],
                        sender: snapshot.data.docs[index]["sender"],
                      );
                    },
                  )
                : Container(
                    child: Text("No chats found"),
                  );
          }),
    );
  }

  sendmessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "sender": widget.username,
        "message": messageController.text,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseService().sendMessageToGroup(widget.groupId, messageMap);
      setState(() {
        messageController.clear();
      });
    }
  }

  messbar() {
    return Row(
      children: [
        Container(
          width: 5,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 5,
              ),
              // ignore: prefer_const_constructors
              Icon(
                Icons.emoji_emotions_outlined,
                color: Colors.black,
                size: 30,
              ),
              SizedBox(
                width: 200,
                child: TextFormField(),
              ),
              Transform.rotate(
                angle: 2 / 3.14,
                child: const IconButton(
                  icon: Icon(
                    Icons.attach_file,
                    color: Colors.black,
                  ),
                  onPressed: null,
                ),
              ),

              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        Container(
          width: 5,
        ),
        CircleAvatar(
          maxRadius: 23,
          backgroundColor: Color.fromARGB(255, 1, 177, 159),
          child: Icon(Icons.mic),
        )
      ],
    );
  }
}
