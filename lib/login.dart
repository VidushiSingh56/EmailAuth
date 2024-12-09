import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectemailauthdec1/Students/screenA.dart';
import 'package:projectemailauthdec1/Tutors/screenB.dart';
import 'package:projectemailauthdec1/forgot.dart';
import 'package:projectemailauthdec1/signup.dart';

import 'homepage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signIn() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      // If either email or password is empty, show a Snackbar
      Get.snackbar(
        "No entry.",
        "Please enter both email and password.",
        margin: EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
      );
      return; // Exit the function early
    }

    try {
      // Sign in the user
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.text, password: password.text);

      // Get the current user's ID
      final String userId = userCredential.user!.uid;

      // Retrieve the user's role from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role']; // Assuming the 'role' field is saved

        // Redirect the user based on their role
        if (role == 'Student') {
          Get.offAll(() => ScreenA()); // Replace with your Student screen
        } else if (role == 'Tutor') {
          Get.offAll(() => ScreenB()); // Replace with your Tutor screen
        } else {
          // Handle unknown roles
          Get.snackbar(
            "Error",
            "Unknown role assigned to the user.",
            margin: EdgeInsets.all(20),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
          );
        }
      } else {
        // Handle case where user document doesn't exist
        Get.snackbar(
          "Error",
          "User data not found.",
          margin: EdgeInsets.all(20),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
        );
      }
    } catch (e) {
      // If login fails, show a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email or password. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Color(0xFF34B89B) // ARGB format
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Center(
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
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      minimumSize: Size(130, 50),// Background color of the button
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20// Text color
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  // Center the "Not a user? Register Now" text
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Ensures the row only takes the necessary width
                      children: [
                        Text("Not a user?  "),
                        GestureDetector(
                          onTap: (){
                            Get.to(Signup());
                          },
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                              fontWeight: FontWeight.w900, // Makes it look like a link
                            ),
                          ),

                        ),
                      ],
                    ),

                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: (){
                      Get.to(Forgot());
                    },
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),


                  ),


                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFFFFFFFF)
    );

  }
}
