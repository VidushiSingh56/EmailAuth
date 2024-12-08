import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:projectemailauthdec1/login.dart';

class ScreenA extends StatefulWidget {
  const ScreenA({super.key});

  @override
  State<ScreenA> createState() => _ScreenAState();
}

class _ScreenAState extends State<ScreenA> {

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
          title: Text("Screen A")
      ),
      body: Center(
        child: Text(
          "HIII student ${user!.email}",
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
