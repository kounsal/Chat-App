import 'package:chat_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red,
        title: const Text("Group Info"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.red.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.red,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group : ${widget.groupName}"),
                      Text("Admin : ${getName(widget.adminname)}"),
                    ],
                  )
                ],
              ),
            ),
            memberlist(),
          ],
        ),
      ),
    );
  }

  memberlist() {
    return StreamBuilder(
      stream: members,
      builder: ((context, AsyncSnapshot sanapshot) {
        if (sanapshot.hasData) {
          if (sanapshot.data['members'] != null) {
            if (sanapshot.data['members'].length != 0) {
              return (SingleChildScrollView(
                child: ListView.builder(
                  itemCount: sanapshot.data['members'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      // ignore: sort_child_properties_last
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.red,
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
                        subtitle: Text(getId(sanapshot.data['members'][index])),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                    );
                  },
                ),
              ));
            } else {
              return const Center();
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
      }),
    );
  }
}
