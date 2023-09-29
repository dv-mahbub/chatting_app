import 'package:chatting_app/components/custom_text_field.dart';
import 'package:chatting_app/pages/register_page.dart';
import 'package:chatting_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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

              const SizedBox(height: 20,),

              //welcome message
              const Text(
                "Welcome back!",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20,),

              //email text field
              CustomTextField(
                  controller: emailController,
                  hintText: "Enter your E-mail",
                  obscureText: false
              ),

              const SizedBox(height: 20,),

              //password text field
              CustomTextField(
                controller: passwordController,
                hintText: "Enter password",
                obscureText: true,
              ),

              const SizedBox(height: 17,),

              //login button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: signIn,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(45, 10,45,10),
                  child: Text(
                   'Sign In',
                    style: TextStyle(fontSize: 17),
                  ),
                )
              ),

              const SizedBox(height: 20,),

              //sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member?", style: TextStyle(fontSize: 16),),
                  TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const RegisterPage()));}, child: const Text("Sign up", style: TextStyle(fontSize: 17, color: Colors.teal,fontWeight: FontWeight.bold),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    //get the auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try{
      await authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
      Navigator.pop(context);
    } catch(e){
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
