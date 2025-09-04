import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectemailauthdec1/Information/locations.dart';
import 'package:projectemailauthdec1/Information/role.dart';
import 'package:projectemailauthdec1/Tutors/home_tutor.dart';
import 'package:projectemailauthdec1/authentication/forgot.dart';
import 'package:projectemailauthdec1/authentication/signup.dart';

import 'package:projectemailauthdec1/Students/home_student.dart';
import '../Information/details.dart';
import '../widgets/ErrorSnackbar.dart';
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
        "No Entry",
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
        // Cast the data to a Map
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        String role = userData['role'] ?? '';
        String emails = userData['email'] ?? '';
        String? locationName = userData['location'];
        String? name = userData['name'];

        if (role == 'Tutor' || role == 'Student') {
          // Check if location is not filled or doesn't exist
          if (locationName == null || locationName.isEmpty) {
            Get.offAll(() => Locations(email: emails, role: role)); // Redirect to Locations page
            return;
          }

          // Check if name is not filled or doesn't exist
          if (name == null || name.isEmpty) {
            Get.offAll(() => Details(
              email: emails,
              role: role,
              locationName: locationName, // Send location name
            )); // Redirect to Details page
            return;
          }

          // Redirect to the respective home screen based on role
          if (role == 'Tutor') {
            print("$emails $role");
            Get.offAll(() => HomeB());
          } else if (role == 'Student') {
            print("$emails $role");
            Get.offAll(() => HomeA());
          }
        } else
        {
          // Get.snackbar(
          //   "Error",
          //   "Unknown role assigned to the user.",
          //   margin: EdgeInsets.all(20),
          //   snackPosition: SnackPosition.BOTTOM,
          //   backgroundColor: Colors.red.withOpacity(0.8),
          // );
          Get.offAll(() => Choose());
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
      CustomRedSnackbar.showSnackbar(
        titleText: "Sign-in Failed",
        messageText: "Invalid email or password. Please try again.",
      );


    }
  }
  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        ),
        home: Scaffold(
            appBar: AppBar(
                title: Text("Login"),
                backgroundColor: Color(0xFF34B89B) // ARGB format
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SingleChildScrollView( // Added SingleChildScrollView
                    padding: const EdgeInsets.all(20.0), // Padding moved here
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                    Padding(
                    padding: const EdgeInsets.only(bottom: 30.0), // Adds space below the image
                    child: Image( // Using your provided Image widget structure
                      width: 350,
                      image: const AssetImage('assets/images/man-getting-award-writing.png'), // Ensure this path is correct
                      errorBuilder: (context, error, stackTrace) {
                        // Optional: Print the error for debugging
                        print("Error loading asset image: $error");
                        print("Stack trace: $stackTrace");
                        return const Icon(
                          Icons.broken_image,
                          size: 250, // Match a similar size or adjust
                          color: Colors.grey, // Changed color for better visibility if on white background
                        );
                      },
                    ),
                  ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: email,
                              decoration: InputDecoration(hintText: 'Enter email'),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: password,
                              obscureText: true,
                              decoration: InputDecoration(hintText: 'Enter password'),
                            ),
                            SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                minimumSize: Size(130, 50),
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20),
                              ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Not a user?  "),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(Signup());
                                    },
                                    child: Text(
                                      "Register Now",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                Get.to(Forgot());
                              },
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )

            ),
            backgroundColor: Color(0xFFFFFFFF)
        ),
      );

  }
}
