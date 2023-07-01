import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final String? userId;

  Database({this.userId});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  Future savingUserData(String name, String email) async {
    return await userCollection.doc(userId).set({
      'name': name,
      'email': email,
      'groups': [],
      'profilpic': '',
      'userId': userId,
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();
    return snapshot;
  }

  Future<Stream<DocumentSnapshot<Object?>>> getUserChats() async {
    return userCollection.doc(userId).snapshots();
  }

  Future creatChat(String name, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': '${id}_$name',
      'members': [],
      'groupId': "",
      'recentMessage': "",
      'recentMessageSender': "",
    });
    await groupDocumentReference.update({
      'members': FieldValue.arrayUnion(['${userId}_$name']),
      'groupId': groupDocumentReference.id
    });
    DocumentReference userDocumentReference = userCollection.doc(userId);
    return await userDocumentReference.update({
      'groups':
          FieldValue.arrayUnion(['${groupDocumentReference.id}_$groupName']),
    });
  }

  getChats(String chatId) async {
    return groupCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  Future getGroupAdmin(String chatId) async {
    DocumentReference d = groupCollection.doc(chatId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }
  Future getLastMessage(String chatId) async {
    DocumentReference d = groupCollection.doc(chatId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['recentMessage'];
  }

  Future<Stream<DocumentSnapshot<Object?>>> getMembers(chatId) async {
    return groupCollection.doc(chatId).snapshots();
  }

  search(String chatName) async {
    return groupCollection.where('groupName', isEqualTo: chatName).get();
  }

  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(userId);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    DocumentReference userDocumentReference = userCollection.doc(userId);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${userId}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${userId}_$userName"])
      });
    }
  }

  sendMessages(String chatId, Map<String , dynamic> messagesData)async{
    groupCollection.doc(chatId).collection('messages').add(messagesData);
    groupCollection.doc(chatId).update({
      'recentMessage':messagesData['message'],
      'recentMessageSender':messagesData['sender'],
      'recentMessageTime':messagesData['time'].toString(),

    });
  }
}
