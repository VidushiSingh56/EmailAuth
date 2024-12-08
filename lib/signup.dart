import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectemailauthdec1/wrapper.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signUp() async {
    try {
      // Create a new user in Firebase Authentication
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // Navigate to the Wrapper to handle redirection
      Get.offAll(() => Wrapper());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Display a message if the email is already in use
        Get.snackbar(
          "Error",
          "The email address is already registered.",
          snackPosition: SnackPosition.BOTTOM,
          // backgroundColor: Colors.redAccent,
          // colorText: Colors.white,
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: Color(0xE7F6E107), // ARGB format
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: email,
                  decoration: InputDecoration(hintText: 'Enter email'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: password,
                  obscureText: true, // To hide the password input
                  decoration: InputDecoration(hintText: 'Enter password'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => signUp(), // Call the signUp method
                  child: Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xB5CFEAA5),
    );
  }
}
