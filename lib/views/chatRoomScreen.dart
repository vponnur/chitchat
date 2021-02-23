import 'package:ChitChat/helpers/constants.dart';
import 'package:ChitChat/helpers/helperfunctions.dart';
import 'package:ChitChat/services/database.dart';
import 'package:ChitChat/views/conversationScreen.dart';
import 'package:ChitChat/views/search.dart';
import 'package:ChitChat/widgets/commonWidget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  DatabaseMethods _db = DatabaseMethods();
  Stream chatRoomStream;
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSP();
    Constants.myId = await HelperFunctions.getUserIdSP();
    getChatRoomInfo();
  }

  getChatRoomInfo() {
    _db.getChatRooms(Constants.myId).then((val) {
      setState(() {
        chatRoomStream = val;
      });
    });
  }

  getReceiverInfo() {}

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: ChatRoomsTile(
                        snapshot.data.documents[index].data['users'].toString(),
                        snapshot.data.documents[index].data['chatRoomId'],
                      ),
                    );
                  },
                )
              : Container(
                  child: Text(
                    "\n\n\n Dear ${Constants.myName}, \n\n Welcome... to ChitChat App \n\n \t\t You don't have any chatroom history. \n\n  \t\t\t  Search and Chat with your friends.",
                    style: simpleTextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, title: "Chat Room"),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          },
        ),
      ),
      body: chatRoomList(),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  const ChatRoomsTile(this.userName, this.chatRoomId);

  getReceiverDetails() {
    var name = userName?.split(',')[0].contains(Constants.myName)
        ? userName.split(',')[1]
        : userName.split(',')[0];
    name = name.replaceAll('[', '').replaceAll(']', '').trim();
    return name;
  }

  getReceiverId() {
    var id = chatRoomId.split('_')[0].contains(Constants.myId)
        ? chatRoomId.split('_')[1].trim()
        : chatRoomId.split('_')[0].trim();
    return id;
  }

  @override
  Widget build(BuildContext context) {
    final String receiverName = getReceiverDetails();
    final String receiverId = getReceiverId();

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(
                      chatRoomId: chatRoomId,
                      receiverId: receiverId,
                      receiverName: receiverName,
                    )));
      },
      child: Container(
        //color: Colors.black26,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                "${receiverName.substring(0, 1).toUpperCase()}",
                //"${userName.substring(0, 1).toUpperCase()}",
                style: simpleTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              receiverName,
              style: simpleTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
