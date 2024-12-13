import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectemailauthdec1/Information/locations.dart';
import 'package:projectemailauthdec1/Tutors/home_tutor.dart';
import 'package:projectemailauthdec1/authentication/forgot.dart';
import 'package:projectemailauthdec1/authentication/signup.dart';

import 'package:projectemailauthdec1/Students/home_student.dart';
import '../Information/details.dart';
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
      Get.snackbar(
        "No entry.",
        "Please enter both email and password.",
        margin: EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.text, password: password.text);

      final String userId = userCredential.user!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'];
        String emails = userDoc['email'];
        bool isLocationFilled = userDoc['location'] != null;
        // bool isDetailsFilled = userDoc['detailsFilled'] ?? false;

        if (role == 'Tutor' || role == 'Student') {
          if (!isLocationFilled) {
            Get.offAll(() => Locations(email: email.text, role : role)); // Pass email
            return;
          }

          // if (!isDetailsFilled) {
          //   Get.offAll(() => Details(
          //     email: email.text,
          //     role : role,
          //     locationName: userDoc['location'],
          //   )); // Pass email
          //   return;
          // }

          if (role == 'Tutor') {
            print(emails + "" + role);
            Get.offAll(() => HomeB());

          } else if (role == 'Student') {
            print(emails + "" + role);
            Get.offAll(() => HomeA());
          }
        } else {
          Get.snackbar(
            "Error",
            "Unknown role assigned to the user.",
            margin: EdgeInsets.all(20),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "User data not found.",
          margin: EdgeInsets.all(20),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
        );
      }
    } catch (e) {
      print("Sign-in Error: $e");
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
