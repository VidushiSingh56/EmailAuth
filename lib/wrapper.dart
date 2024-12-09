import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore package
import 'package:projectemailauthdec1/choose.dart';
import 'package:projectemailauthdec1/login.dart';
import 'package:projectemailauthdec1/Students/screenA.dart';
import 'package:projectemailauthdec1/Tutors/screenB.dart';
import 'package:projectemailauthdec1/verify.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  // Function to get the user's role from Firestore
  Future<String?> getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot roleDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      return roleDoc['role']; // Return the saved role
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot)
        {
          // Check if user is authenticated
          if (snapshot.hasData)
          {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null)
            {
              // Check role and navigate accordingly
              return FutureBuilder<String?>(
                future: getUserRole(),
                builder: (context, roleSnapshot)
                {
                  if (roleSnapshot.connectionState == ConnectionState.waiting)
                  {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (roleSnapshot.hasData)
                  {
                    if (roleSnapshot.data == 'Student')
                    {
                      return ScreenA(); // Navigate to Student screen
                    } else if (roleSnapshot.data == 'Tutor')
                    {
                      return ScreenB(); // Navigate to Tutor screen
                    }
                  }
                  return Choose(); // Default to role selection if no role
                },
              );
            }
          }
          // Return the login screen if no user is authenticated
          return Login();
        },
      ),
    );
  }
}
