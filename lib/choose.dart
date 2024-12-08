import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projectemailauthdec1/Students/screenA.dart';

import 'Tutors/screenB.dart';

class Choose extends StatefulWidget {
  const Choose({super.key});

  @override
  State<Choose> createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose"),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to Screen A
                Get.to(() => ScreenA());
              },
              child: Container(
                width: 200.0, // Circle's diameter
                height: 200.0,
                decoration: BoxDecoration(
                  color: Color(0xFC009124), // Circle's color
                  shape: BoxShape.circle, // Makes the container circular
                ),
                child: Center(
                  child: Text(
                    "Student",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                // Navigate to Screen A
                Get.to(() => ScreenB());
              },
              child: Container(
                width: 200.0, // Circle's diameter
                height: 200.0,
                decoration: BoxDecoration(
                  color: Colors.blue, // Circle's color
                  shape: BoxShape.circle, // Makes the container circular
                ),
                child: Center(
                  child: Text(
                    "Tutor",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
