import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  late final String uid;

  //constructor for passing user id
  DatabaseService({required this.uid});
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

}
