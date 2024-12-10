import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this for Firestore
import 'package:get/get.dart';
import 'package:projectemailauthdec1/Information/locations.dart';
import 'package:projectemailauthdec1/Tutors/home_tutor.dart';

import '../login.dart';

class Choose extends StatefulWidget {
  const Choose({super.key});

  @override
  State<Choose> createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {
  // Function to save the user's role in Firestore
  String userEmail = "";
  String userRole = "";
  void initState()
  {
    super.initState();
    fetchUserEmail();
  }

  off() async {
    await FirebaseAuth.instance.signOut();
    // Navigate to the login screen and clear the navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
    );
  }

  //Fetch user email from Firestore
  void fetchUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? "";
      });
    }
  }

  void saveRole(String role) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'role': role,         // Save the role
        'email': user.email,

      });
      // Save the role in Firestore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "Choose",
              style: TextStyle(
                  fontSize: 30, // Font size
                  color: Colors.white
              ),
            ),
          ),
          backgroundColor: Color(0xFF34B89B), // Background color
          toolbarHeight: 90.0, // Increase AppBar height
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                GestureDetector(
                  onTap: () {
                    saveRole("Student"); // Save role as Student
                    userRole = "Student";
                    Get.to(() => Locations(email : userEmail, role : userRole)); // Navigate to Student screen
                  },
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "Student",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    saveRole("Tutor");
                    userRole = "Tutor";// Save role as Tutor
                    Get.to(() => Locations(email : userEmail, role : userRole)); // Navigate to Tutor screen
                  },
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "Tutor",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],

            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: off,
          child: Icon(Icons.exit_to_app),
          backgroundColor: Color(0xD59DE1D2),
        ),
        backgroundColor: Color(0xFF34B89B)
    );
  }
}