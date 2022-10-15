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
        "recentMessageTime": "",
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
  Future getChat(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
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

//toggling the group join or exit
  Future toggleGroupJoin(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocumentRefrence =
        userCollection.doc(uid); //getting the reference of user
    DocumentReference groupDocumentRefrence = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await userDocumentRefrence.get();
    List<dynamic> groups = documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentRefrence.update({
        "groups": FieldValue.arrayRemove(
            ["${groupId}_$groupName"]), //removing group id from user
      });
      await groupDocumentRefrence.update({
        "members": FieldValue.arrayRemove(
            ["${uid}_$userName"]) //removing member from groupName
      });
    } else {
      await userDocumentRefrence.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentRefrence.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  //send message to group
  sendMessageToGroup(
      String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update(
      {
        "recentMessage": chatMessageData["message"],
        "recentMessageSender": chatMessageData["sender"],
        "recentMessageTime": chatMessageData["time"],
      },
    );
  }
}
