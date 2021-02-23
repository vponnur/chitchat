import 'package:ChitChat/helpers/constants.dart';
import 'package:ChitChat/helpers/helperfunctions.dart';
import 'package:ChitChat/services/database.dart';
import 'package:ChitChat/widgets/commonWidget.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String receiverId;
  final String receiverName;
  ConversationScreen({this.chatRoomId, this.receiverId, this.receiverName});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods _db = DatabaseMethods();
  TextEditingController messageController = TextEditingController();
  Stream chatMessageStream;

  @override
  void initState() {
    super.initState();
    _db.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    getUsersInfo(widget.chatRoomId);
  }

  getReceriverInfo() {
    Constants.reciverId = widget.receiverId;
    Constants.reciverName = widget.receiverName;
  }

  getUsersInfo(String chatRoomId) {
    if (Constants.reciverId.isEmpty) {
      var rID = chatRoomId.replaceAll(Constants.myId, '').replaceAll('_', '');
      _db.getUserByUserId(rID).then((data) {
        if (data != null) {
          Constants.reciverId = rID;
          Constants.reciverName = data.documents[0].data[Constants.name];
          HelperFunctions.saveReceiverNameSP(
              data.documents[0].data[Constants.name]);
          HelperFunctions.saveReceiverIdSP(data.documents[0].data[rID]);
         
        }
      });
    }
  }

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data.documents[index].data['message'],
                        snapshot.data.documents[index].data['sendBy'] ==
                            Constants.myName);
                  },
                )
              : Container();
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'sendBy': Constants.myName,
        'receivedBy': Constants.reciverName,
        'message': messageController.text.trim(),
        'timeStamp': DateTime.now().millisecondsSinceEpoch,
      };
      _db.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: <Widget>[
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding:const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "type message here ...",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: sendMessage,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF),
                          ]),
                          borderRadius: BorderRadius.circular(80),
                        ),
                        padding:const EdgeInsets.all(5),
                        child: Icon(
                          Icons.radio_button_checked,
                          color: Color(colorLinerBlue),
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isMe;
  MessageTile(this.message, this.isMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isMe ? 0 : 24, right: isMe ? 24 : 0),
      margin:const EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding:const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: isMe
                  ? [
                      const Color(0xff007EF4),
                      const Color(0xff2A75BC),
                    ]
                  : [
                      const Color(0x1AFFFFFF),
                      const Color(0x1AFFFFFF),
                    ]),
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
