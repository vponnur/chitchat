import 'package:ChitChat/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  var userRef = Firestore.instance.collection(Constants.users);
  var chatRoomRef = Firestore.instance.collection(Constants.chatRoom);

  getUserByUserName(String userName) async {
    return await userRef
        .where(Constants.name, isGreaterThanOrEqualTo: userName)
        .getDocuments();
  }

  getUserByUserEmail(String email) async {
    return await userRef
        .where(Constants.email, isEqualTo: email)
        .getDocuments();
  }

  getUserByUserId(String userId) async {
    return await userRef.where(Constants.id, isEqualTo: userId).getDocuments();
  }

//userData = id, name, email
  uploadUserInfo(userData) {
    userRef.add(userData).catchError((e) => {});
  }

  createChatRoom(String chatRoomId, chatRoomMap) async {
    await chatRoomRef
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) => {});
  }

  addConversationMessages(String chatRoomId, messageMap) async {
    await chatRoomRef
        .document(chatRoomId)
        .collection(Constants.chats)
        .add(messageMap)
        .catchError((e) => {});
  }

  getConversationMessages(String chatRoomId) async {
    try {
      return chatRoomRef
          .document(chatRoomId)
          .collection(Constants.chats)
          .orderBy(Constants.timeStamp, descending: false)
          .snapshots();
    } catch (e) {}
  }

  getChatRooms(String userId) async {
    return chatRoomRef
        .where(Constants.userIds, arrayContains: userId)
        .snapshots();
  }
}
