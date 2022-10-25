// ignore_for_file: file_names

import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminname;

  const GroupInfo({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.adminname,
  });

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  QuerySnapshot? adminSnapshot;
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMember(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  checkadmin(username) {
    if (username == widget.adminname) {
      return true;
    } else {
      return false;
    }
  }

  leave() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .leaveGroup(widget.groupId, widget.groupName);
  }

  delete() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .deleteGroup(widget.groupId, widget.groupName);
    leave();
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 207, 208),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: members,
              builder: (context, AsyncSnapshot snapshot) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      header(snapshot),
                      const SizedBox(height: 7.0),
                      Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 236, 184, 186)),
                        child: memberlist(snapshot),
                      ),
                      const SizedBox(height: 7.0),
                      footer(),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  header(sanapshot) {
    return Container(
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 236, 184, 186)),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Stack(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Positioned(
                left: 10,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              Expanded(
                  child: Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Theme.of(context).primaryColor,
                  child:
                      const Icon(Icons.person, size: 60, color: Colors.white),
                ),
              )),
              const Positioned(
                right: 10,
                child: Icon(
                  Icons.more_vert,
                ),
              ),
            ],
          ),
          ListTile(
            title: Center(
              child: Text(
                widget.groupName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: check(sanapshot),
          ),
        ],
      ),
    );
  }

  Widget check(sanapshot) {
    if (sanapshot.hasData) {
      if (sanapshot.data['members'] != null) {
        if (sanapshot.data['members'].length != 0) {
          return (Center(
            child: Text.rich(
              TextSpan(
                text: "Group ",
                children: [
                  const WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.circle,
                      size: 4,
                    ),
                  ),
                  TextSpan(
                      text: " ${sanapshot.data['members'].length} participants")
                ],
              ),
            ),
          ));
        } else {
          return const Center(
            child: Text("No Members"),
          );
        }
      } else {
        return const Center(
          child: Text("No Members"),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      );
    }
  }

  Widget footer() {
    return Container(
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 236, 184, 186)),
      child: Column(
        children: [
          const SizedBox(height: 5),
          ListTile(
            leading: const Icon(Icons.person_remove),
            title: const Text("Leave Group"),
            onTap: () {
              leave();
              nextScreenReplace(context, Homepage());
            },
          ),
          !checkadmin(FirebaseAuth.instance.currentUser!)
              ? ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete Group"),
                  onTap: () {
                    delete();

                    nextScreenReplace(context, Homepage());
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  memberlist(sanapshot) {
    if (sanapshot.hasData) {
      if (sanapshot.data['members'] != null) {
        if (sanapshot.data['members'].length != 0) {
          return ListView.builder(
            itemCount: sanapshot.data['members'].length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                // ignore: sort_child_properties_last
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      getName(sanapshot.data['members'][index])
                          .substring(0, 1)
                          .toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(getName(sanapshot.data['members'][index])),
                  trailing: checkadmin(sanapshot.data['members'][index])
                      ? Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(117, 194, 183, 151)),
                          padding: const EdgeInsets.all(5),
                          child: const Text("Admin"),
                        )
                      : Container(
                          width: 0,
                        ),
                  subtitle: Text(getId(sanapshot.data['members'][index])),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              );
            },
          );
        } else {
          return const Center(
            child: Text("No Members"),
          );
        }
      } else {
        return const Center(
          child: Text("No Members"),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      );
    }
  }
}
