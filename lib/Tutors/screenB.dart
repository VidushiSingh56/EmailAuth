import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectemailauthdec1/login.dart';

class ScreenB extends StatefulWidget {
  const ScreenB({super.key});

  @override
  State<ScreenB> createState() => _ScreenAState();
}

class _ScreenAState extends State<ScreenB> {

  final user = FirebaseAuth.instance.currentUser;

  signout() async {
    await FirebaseAuth.instance.signOut();
    // Navigate to the login screen and clear the navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()), // Replace with your LoginScreen widget
          (route) => false, // Remove all previous routes
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Screen B")
      ),
      body: Center(
        child: Text(
          "HIII Tutor ${user!.email}",
          style: TextStyle(
            fontSize: 24, // Increases the font size
            fontWeight: FontWeight.bold, // Makes the text bold
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => signout()),
        child: Icon(Icons.login_rounded),
      ),

    );
  }
}
