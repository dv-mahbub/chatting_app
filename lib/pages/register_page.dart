import 'package:chatting_app/components/custom_text_field.dart';
import 'package:chatting_app/pages/homepage.dart';
import 'package:chatting_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //logo
              const Icon(Icons.ac_unit, size: 80, color: Colors.teal,),

              const SizedBox(height: 17,),

              //welcome message
              const Text(
                "Let's create!",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 17,),

              //name text field
              CustomTextField(
                  controller: nameController,
                  hintText: "Enter your name",
                  obscureText: false
              ),

              const SizedBox(height: 17,),

              //email text field
              CustomTextField(
                  controller: emailController,
                  hintText: "Enter your E-mail",
                  obscureText: false
              ),

              const SizedBox(height: 17,),

              //password text field
              CustomTextField(
                controller: passwordController,
                hintText: "Enter password",
                obscureText: true,
              ),

              const SizedBox(height: 17,),

              //confirm password text field
              CustomTextField(
                controller: confirmPasswordController,
                hintText: "Enter password",
                obscureText: true,
              ),

              const SizedBox(height: 17,),

              //login button
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: signUp, child: const Padding(
                padding: EdgeInsets.fromLTRB(45,10,45,10),
                child: Text('Sign Up'),
              )),

              const SizedBox(height: 17,),

              //sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already a member?", style: TextStyle(fontSize: 17),),
                  TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage()));}, child: const Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.teal),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    if(passwordController.text != confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Confirm password not matched')));
    } else {
      final authService = Provider.of<AuthService>(context, listen: false);
      try{
        await authService.signUpWithEmailAndPassword(emailController.text, passwordController.text, nameController.text);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Homepage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
