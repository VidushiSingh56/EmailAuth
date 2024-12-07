import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projectemailauthdec1/wrapper.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {

  TextEditingController email = TextEditingController();

  reset()async
  {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
    Get.offAll(Wrapper());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor: Color(0xE7F6E107), // ARGB format
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
                  ElevatedButton(
                    onPressed: () => reset(),
                    child: Text("Send Link"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xB5D2EFA1),
    );
  }
}
