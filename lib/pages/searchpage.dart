import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Searchpage extends StatefulWidget {
  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  User? user;
  String userName = '';

  void initState() {
    super.initState();
    getcurrentUserIdandName();
  }

  getcurrentUserIdandName() async {
    await HelperFunction.getUserName().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: AppBar(
        actions: [],
        elevation: 0,
        backgroundColor: Colors.red,
        title: const Text(
          "Search",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      // ignore: prefer_const_constructors
      body: Column(
        children: [
          Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    // ignore: avoid_print
                    onChanged: (val) => print(val),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Group",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                      // enabledBorder: OutlineInputBorder(
                      //     borderSide:
                      //         BorderSide(color: Colors.orangeAccent[700]!)),
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide:
                      //       BorderSide(color: Colors.orangeAccent[700]!),
                      // ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                )
              : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService()
          .getGroupsByName(searchController.text)
          .then((val) {
        setState(() {
          searchSnapshot = val;
          _isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                  userName,
                  searchSnapshot!.docs[index]['groupId'],
                  searchSnapshot!.docs[index]['groupName'],
                  searchSnapshot!.docs[index]['admin']);
            },
          )
        : Container();
  }

  Widget groupTile(
      String userName, String groupid, String groupName, String admin) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.red,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(groupName),
      subtitle: Text("Admin : ${admin.substring(admin.indexOf("_") + 1)}"),
    );
  }
}
