import 'package:chatting_app/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../pages/homepage.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for the authentication state.
            return const CircularProgressIndicator();
          }
          //if logged in
          else if(snapshot.hasData){
            return const Homepage();
          }
          //if not logged in
          else{
            return const LoginPage();
          }

        },
      ),
    );
  }
}
