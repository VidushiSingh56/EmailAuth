import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectemailauthdec1/login.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController email = TextEditingController();

  reset() async {
    if (email.text.isEmpty) {
      // Show an error if email is empty
      Get.snackbar(
        "Error",
        "Please enter your email address.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(20),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);

      // Notify user about the email
      Get.snackbar(
        "Email Sent",
        "A password reset link has been sent to your email.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(20),
      );

      // Redirect to login page after a delay
      Future.delayed(Duration(seconds: 2), () {
        Get.offAll(() => Login());
      });
    } catch (e) {
      // Handle errors, such as invalid email
      Get.snackbar(
        "Error",
        "Failed to send reset email. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: EdgeInsets.all(20),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
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
                    decoration: InputDecoration(
                      hintText: 'Enter email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: reset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      minimumSize: Size(130, 50),// Background color of the button
                    ),
                    child: Text(
                      "Send Reset Link",
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
      ),
      backgroundColor: Color(0xFFFFFFFF),
    );
  }
}
