import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  late String? uid;

  //constructor for passing user id
  DatabaseService({this.uid});
//refrence for our collections

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  //updating/ save user data

  Future savingUserData(String fullname, String email) async {
    return await userCollection.doc(uid).set(
      {
        "fullname": fullname,
        "email": email,
        "groups": [],
        "profilepic": "",
        "uid": uid,
      },
    );
  }

//get user data

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();

    return snapshot;
  }

  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // create a group

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupdocumentReference = await groupCollection.add(
      {
        "groupName": groupName,
        "groupIcon": "",
        "admin": "${id}_$userName",
        "members": [],
        "groupId": "",
        "recentMessage": "",
        "recentMessageSender": "",
      },
    );
    await groupdocumentReference.update(
      {
        "members": FieldValue.arrayUnion(["${uid}_$userName"]),
        "groupId": groupdocumentReference.id,
      },
    );
    DocumentReference userDocumentRefrence = await userCollection.doc(uid);
    return await userDocumentRefrence.update({
      "groups":
          FieldValue.arrayUnion(["${groupdocumentReference.id}_$groupName"]),
    });
  }

  //getting chat
  getChat(String groupId) {
    return groupCollection
        .doc(groupId)
        .collection("messages") //creating new collection or using this one
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference abc = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await abc.get();
    return documentSnapshot["admin"];
  }

  // get Group Members
  Future getGroupMember(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

//searching groups
  Future getGroupsByName(String groupName) async {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

//is user joined

  Future<bool> isuserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentRefrence = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentRefrence.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }
}
