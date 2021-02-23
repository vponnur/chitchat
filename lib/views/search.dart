import 'package:ChitChat/helpers/constants.dart';
import 'package:ChitChat/helpers/helperfunctions.dart';
import 'package:ChitChat/services/database.dart';
import 'package:ChitChat/views/conversationScreen.dart';
import 'package:ChitChat/widgets/commonWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods _db = DatabaseMethods();
  TextEditingController searchController = TextEditingController();
  QuerySnapshot searchResultSnapshot;
  searchUser() {
    _db.getUserByUserName(searchController.text.trim()).then((val) {
      setState(() {
        searchResultSnapshot = val;
      });
    });
  }

  createChatRoomConversation(String userId, String userName, String userEmail) {
    if (userId != Constants.myId) {
      String chatRoomId = getChatRoomId(userId, Constants.myId);
      List<String> users = [userName, Constants.myName];
      List<String> userIds = [userId, Constants.myId];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "userIds": userIds,
        "chatRoomId": chatRoomId,
      };
      Constants.reciverId = userId;
      Constants.reciverName = userName;
      HelperFunctions.saveReceiverIdSP(userId);
      HelperFunctions.saveReceiverNameSP(userName);
      HelperFunctions.saveReceiverEmailSP(userEmail);

      _db.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomId: chatRoomId,
                    receiverId: userId,
                    receiverName: userName,
                  )));
    }
  }

  Widget searchList() {
    return searchResultSnapshot == null
        ? Center(
            child: Container(), //CircularProgressIndicator(),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.documents.length,
            itemBuilder: (context, index) {
              return searchTile(
                userId:
                    searchResultSnapshot.documents[index].data[Constants.id],
                userName:
                    searchResultSnapshot.documents[index].data[Constants.name],
                userEmail:
                    searchResultSnapshot.documents[index].data[Constants.email],
              );
            });
  }

  Widget searchTile({String userId, String userName, String userEmail}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(userName, style: simpleTextStyle()),
              Text(userEmail, style: simpleTextStyle(fontSize: 12)),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () =>
                createChatRoomConversation(userId, userName, userEmail),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text("Message", style: simpleTextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, signOut: false),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Search username",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: searchUser,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0x36FFFFFF),
                          const Color(0x0FFFFFFF),
                        ]),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String myId, String otherId) {
  if (myId != null && otherId != null) {
    if (myId.toString().compareTo(otherId.toString()) == 1) {
      return "$myId\_$otherId";
    } else if (myId.toString().compareTo(otherId.toString()) == -1) {
      return "$otherId\_$myId";
    }
  }
}
