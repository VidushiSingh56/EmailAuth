import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectemailauthdec1/choose.dart';
import 'package:projectemailauthdec1/wrapper.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // Function to sign up the user
  signUp() async {
    try {
      // Create a new user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // Get the current user UID
      User? user = userCredential.user;

      // Check if the user is not null and if the email is available
      if (user != null && user.email != null) {
        print("User email: ${user.email}"); // Debugging line

        // Create a reference to Firestore and add the user details
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,        // User's email
          'role': 'new',              // You can set role to "new" or any default role
        });

        // Navigate to the Wrapper to handle redirection
        Get.offAll(() => Choose());
      } else {
        // If user email is null, display an error
        print("Error: Email is null");
      }
    } on FirebaseAuthException catch (e)
    {
      if (e.code == 'email-already-in-use') {
        // Display a message if the email is already in use
        Get.snackbar(
          "Error",
          "The email address is already registered.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Handle other errors
        Get.snackbar(
          "Error",
          e.message ?? "An error occurred during sign up.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
          backgroundColor: Color(0xFF34B89B)  // ARGB format
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                SizedBox(height: 50),
            ElevatedButton(
              onPressed: signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                minimumSize: Size(130, 50),// Background color of the button
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20// Text color
                ),
              ),
            ),
              ],
            ),
          ),
        ),
      ),
        backgroundColor: Color(0xFFFFFFFF)
    );
  }
}
