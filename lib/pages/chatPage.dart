// ignore_for_file: file_names

import 'dart:async' show Stream, Timer;
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
  final ScrollController _scrollController = ScrollController();

  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
    setState(() {});
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: <Color>[
            Color.fromARGB(240, 198, 255, 221),
            Color.fromARGB(251, 251, 216, 134),
            Color.fromARGB(247, 247, 121, 125),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [
            Expanded(
              child: Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.045,
                  backgroundColor: const Color.fromARGB(75, 0, 0, 0),
                  child: const Icon(
                    Icons.group,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    nextScreen(
                      context,
                      GroupInfo(
                          groupId: widget.groupId,
                          groupName: widget.groupName,
                          adminname: admin),
                    );
                  },
                  child: Text(
                    widget.groupName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                ),
              ]),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //chatbody(),
            messec(),

            messbar(),
          ],
        ),
      ),
    );
  }

  messec() {
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    });
    return SizedBox(
      height: MediaQuery.of(context).viewInsets.bottom == 0
          ? MediaQuery.of(context).size.height * 0.8
          : MediaQuery.of(context).size.height * 0.44,
      child: StreamBuilder(
          stream: chats,
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
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
                : const Text("No chats found");
          }),
    );
  }

  chatbody() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 40),
        child: StreamBuilder(
            stream: chats,
            builder: (context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: (ListView.builder(
                            controller: _scrollController,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return MessageTile(
                                message: snapshot.data.docs[index]["message"],
                                sentByMe: widget.username ==
                                    snapshot.data.docs[index]["sender"],
                                sender: snapshot.data.docs[index]["sender"],
                              );
                            },
                          )),
                        ),
                      ],
                    )
                  : const Text("No chats found");
            }),
      ),
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
        Timer(
            const Duration(milliseconds: 500),
            () => _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent));
      });
    }
  }

  messbar() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                width: 5,
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(45, 77, 63, 63),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 5,
                    ),
                    // ignore: prefer_const_constructors
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.47,
                      child: TextFormField(
                        decoration: const InputDecoration(),
                        controller: messageController,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Transform.rotate(
                      angle: 2 / 3.1415,
                      child: const IconButton(
                        icon: Icon(
                          Icons.attach_file,
                          color: Colors.black,
                        ),
                        onPressed: null,
                      ),
                    ),

                    const IconButton(
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
                backgroundColor: const Color.fromARGB(228, 228, 255, 198),
                child: messageController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          sendmessage();
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.black,
                        ),
                      )
                    : const IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.mic,
                          color: Colors.black,
                        ),
                      ),
              )
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
