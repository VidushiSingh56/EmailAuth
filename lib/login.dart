import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projectemailauthdec1/forgot.dart';
import 'package:projectemailauthdec1/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signIn()async
  {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
                  TextField(
                    controller: password,
                    obscureText: true, // To hide the password input
                    decoration: InputDecoration(hintText: 'Enter password'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: signIn,
                    child: Text("Login"),
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
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: (){
                      Get.to(Forgot());
                    },
                    child: Text(
                      "Forgot Password",
                    ),

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
