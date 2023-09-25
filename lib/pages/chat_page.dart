import 'package:chatting_app/components/chat_bubbles.dart';
import 'package:chatting_app/components/custom_text_field.dart';
import 'package:chatting_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  final String receiverName;
  const ChatPage({super.key, required this.receiverEmail, required this.receiverId, required this.receiverName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> sendMessage() async {
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
      return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Text('Error ${snapshot.error}');
        } if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.data == null){
          // Display a loading spinner or an error message here
          return const Center(child: Text('Error', style: TextStyle(fontSize: 18),));
        }
        return Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: snapshot.data!.docs.map((document)=>_buildMessageItem(document)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    //align messages to right and left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
    ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          alignment==Alignment.centerRight ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ChatBubble(message: data['message'], alignment: alignment),
              const SizedBox(width: 3,),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue,
                child: Text(widget.receiverName[0].toUpperCase(), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),),
              ),
            ],
          )
          :Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue,
                child: Text(widget.receiverName[0].toUpperCase(), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),),
              ),
              const SizedBox(width: 3,),
              ChatBubble(message: data['message'], alignment: alignment),
            ],
          ),
          const SizedBox(height: 6,),
        ],
      ),
    );
  }

  _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: Row(
        children: [
          //text field
          Expanded(
            child: CustomTextField(
              hintText: 'Enter a message',
              controller: _messageController,
              obscureText: false,
            ),
          ),
          //send button
          IconButton(onPressed: sendMessage, icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
