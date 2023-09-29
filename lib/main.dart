import 'package:chatting_app/firebase_options.dart';
import 'package:chatting_app/pages/login_page.dart';
import 'package:chatting_app/pages/register_page.dart';
import 'package:chatting_app/services/auth/auth_gate.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) =>AuthService(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthGate(),
      ),
    )
  );
}