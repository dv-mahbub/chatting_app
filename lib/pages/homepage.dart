import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';
import 'chat_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
        actions: [
          ElevatedButton(onPressed: signOut, child: const Text("Sign Out")),
        ],
      ),
      body: _buildUserList(),
    );
  }

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  //build a list of user except current logged in
  Widget _buildUserList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Text('Error');
        } else if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView(
          children: snapshot.data!.docs
          .map<Widget>((doc)=>_buildUserListItem(doc))
          .toList(),
        );
        }
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //pass all users except current
    if(_auth.currentUser!.email != data['email']){
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Text(data['name'][0].toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),),
            ),
            title: Text(data['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(
                receiverEmail: data['email'],
                receiverName: data['name'],
                receiverId: data['uid'],
              )));
            },
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
